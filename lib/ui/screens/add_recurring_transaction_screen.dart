import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/RecurringTransactionModel.dart';
import '../../router/app_router.dart';
import '../provider/customize_provider.dart';
import '../widgets/app_bottom_nav.dart';

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

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  String _repeatType = 'Hàng Tháng';
  int _categoryId = 3;
  RecurringTransactionModel? _initialItem;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _initialItem =
        ModalRoute.of(context)?.settings.arguments as RecurringTransactionModel?;
    if (_initialItem != null) {
      _nameController.text = _initialItem!.note;
      _amountController.text = _initialItem!.amount.toString();
      _dateController.text = _initialItem!.startDate;
      _repeatType = _initialItem!.repeatCycle;
      _categoryId = _initialItem!.categoryId;
    } else {
      _nameController.text = 'Khoản Định Kỳ';
      _amountController.text = '87.32';
      _dateController.text = '15/10/2024';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final provider = context.read<CustomizeProvider>();
    final model = RecurringTransactionModel(
      id: _initialItem?.id,
      userId: _initialItem?.userId ?? 1,
      categoryId: _categoryId,
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomizeProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 390,
            height: 800,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Scaffold(
                backgroundColor: primary,
                body: Column(
                  children: [
                    Padding(
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
                    Expanded(
                      child: Container(
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
                                  _field(
                                    'Số Tiền',
                                    _amountController,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 12),
                                  _field('Ngày Ghi Lại', _dateController),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Lặp Lại',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    initialValue: _repeatType,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xFFDFF1E1),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Hàng Tháng',
                                        child: Text('Hàng Tháng'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Hàng Ngày',
                                        child: Text('Hàng Ngày'),
                                      ),
                                    ],
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
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Hủy'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        provider.isLoading ? null : _save,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primary,
                                      foregroundColor: const Color(0xFF163C3C),
                                    ),
                                    child: Text(
                                      provider.isLoading ? 'Đang lưu...' : 'Lưu',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const AppBottomNav(
                              currentRoute: AppRouter.customize,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFDFF1E1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
