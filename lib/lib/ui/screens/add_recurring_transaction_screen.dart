import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/RecurringTransactionModel.dart';
import '../../router/app_router.dart';
import '../provider/customize_provider.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_secondary_shell.dart';

class AddRecurringTransactionScreen extends StatefulWidget {
  const AddRecurringTransactionScreen({super.key});

  @override
  State<AddRecurringTransactionScreen> createState() =>
      _AddRecurringTransactionScreenState();
}

class _AddRecurringTransactionScreenState
    extends State<AddRecurringTransactionScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);
  static const Map<String, String> _repeatOptions = {
    'Hang Thang': 'Hàng Tháng',
    'Hang Ngay': 'Hàng Ngày',
  };

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  String _repeatType = 'Hang Thang';
  String _entryType = 'expense';
  int? _categoryId;
  RecurringTransactionModel? _initialItem;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final provider = context.read<CustomizeProvider>();
    _initialItem =
        ModalRoute.of(context)?.settings.arguments as RecurringTransactionModel?;

    if (_initialItem != null) {
      _nameController.text = _initialItem!.note;
      _amountController.text = _initialItem!.amount.toStringAsFixed(2);
      _dateController.text = _initialItem!.startDate;
      _repeatType = _normalizeRepeatType(_initialItem!.repeatCycle);
      _categoryId = _initialItem!.categoryId;
      _entryType = _initialItem!.categoryId <= 2 ? 'income' : 'expense';
    } else {
      _nameController.text = 'Khoản Định Kỳ';
      _dateController.text = '15/10/2024';
      _amountController.text = '87.32';
    }

    provider.loadCategories(type: _entryType).then((_) {
      if (!mounted) return;
      final categories = provider.categories;
      if (_categoryId == null || !categories.any((item) => item.id == _categoryId)) {
        setState(() {
          _categoryId = categories.isEmpty ? null : categories.first.id;
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2024, 10, 15),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final day = picked.day.toString().padLeft(2, '0');
    final month = picked.month.toString().padLeft(2, '0');
    _dateController.text = '$day/$month/${picked.year}';
    setState(() {});
  }

  Future<void> _save() async {
    final provider = context.read<CustomizeProvider>();
    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn hạng mục')),
      );
      return;
    }
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số tiền không hợp lệ')),
      );
      return;
    }
    if (_dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày ghi lại')),
      );
      return;
    }

    final model = RecurringTransactionModel(
      id: _initialItem?.id,
      userId: _initialItem?.userId ?? 1,
      categoryId: _categoryId!,
      amount: amount,
      startDate: _dateController.text.trim(),
      repeatCycle: _repeatType,
      note: _nameController.text.trim(),
    );

    final success = _initialItem == null
        ? await provider.addRecurringTransaction(model)
        : await provider.updateRecurringTransaction(model);

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRouter.recurringTransactions);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Không thể lưu khoản định kỳ',
          ),
        ),
      );
    }
  }

  Future<void> _delete() async {
    final provider = context.read<CustomizeProvider>();
    if (_initialItem?.id == null) return;
    final success = await provider.deleteRecurringTransaction(_initialItem!.id!);
    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, AppRouter.recurringTransactions);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ?? 'Không thể xóa khoản định kỳ',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomizeProvider>();
    final categories = provider.categories;

    return AppSecondaryShell(
      primaryColor: primary,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 20, 18),
        child: Row(
          children: [
            const BackButton(color: Colors.white),
            Expanded(
              child: Text(
                _initialItem == null ? 'Thêm Khoản' : 'Sửa Khoản',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF113939),
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 18,
                color: Color(0xFF155050),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
        decoration: const BoxDecoration(
          color: lightBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _field('Tên Khoản', _nameController),
                  const SizedBox(height: 12),
                  Text(
                    'Hạng Mục',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    initialValue: categories.any((item) => item.id == _categoryId)
                        ? _categoryId
                        : null,
                    decoration: _inputDecoration(),
                    items: categories
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: item.id,
                            child: Text(item.name),
                          ),
                        )
                        .toList(),
                    onChanged: categories.isEmpty
                        ? null
                        : (value) {
                            setState(() {
                              _categoryId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Số Tiền',
                    _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _field(
                    'Ngày Ghi Lại',
                    _dateController,
                    readOnly: true,
                    suffixIcon: IconButton(
                      onPressed: _pickDate,
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: Color(0xFF16C8A0),
                      ),
                    ),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Lặp Lại',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _repeatType,
                    decoration: _inputDecoration(),
                    items: _repeatOptions.entries
                        .map(
                          (entry) => DropdownMenuItem<String>(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _repeatType = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _initialItem == null ? () => Navigator.pop(context) : _delete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_initialItem == null ? 'Hủy' : 'Xóa'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: const Color(0xFF163C3C),
                    ),
                    child: Text(
                      provider.isLoading
                          ? 'Đang lưu...'
                          : (_initialItem == null ? 'Lưu' : 'Cập Nhật'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const AppBottomNav(currentRoute: AppRouter.customize),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          decoration: _inputDecoration().copyWith(suffixIcon: suffixIcon),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFDFF1E1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  String _normalizeRepeatType(String rawValue) {
    final normalized = rawValue.toLowerCase().replaceAll(' ', '');
    if (normalized.contains('ngay')) {
      return 'Hang Ngay';
    }
    return 'Hang Thang';
  }
}
