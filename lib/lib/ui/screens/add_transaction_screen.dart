import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/CategoryModel.dart';
import '../../data/database/models/TransactionModel.dart';
import '../provider/auth_provider.dart';
import '../provider/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color fieldBg = Color(0xFFDFF1E1);

  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  String _type = 'expense';
  CategoryModel? _selectedCategory;
  TransactionModel? _initialTransaction;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _initialTransaction =
        ModalRoute.of(context)?.settings.arguments as TransactionModel?;

    if (_initialTransaction != null) {
      _type = _initialTransaction!.type;
      _amountController.text = _initialTransaction!.amount.toStringAsFixed(0);
      _dateController.text = _fromIsoDate(_initialTransaction!.date);
      _addressController.text = _initialTransaction!.address;
      _noteController.text = _initialTransaction!.note;
    } else {
      _dateController.text = _todayText();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<TransactionProvider>().loadCategories(type: _type);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _todayText() {
    final now = DateTime.now();
    return _formatDate(now);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _fromIsoDate(String text) {
    final parsed = DateTime.tryParse(text);
    return parsed == null ? _todayText() : _formatDate(parsed);
  }

  String _toIsoDate(String text) {
    final parts = text.split('/');
    if (parts.length != 3) {
      return DateTime.now().toIso8601String().split('T').first;
    }
    return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
  }

  double? _parseAmount(String text) {
    final normalized = text.replaceAll(',', '').replaceAll(' ', '').trim();
    return double.tryParse(normalized);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_toIsoDate(_dateController.text)) ??
          DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    _dateController.text = _formatDate(picked);
    setState(() {});
  }

  Future<void> _save() async {
    final authProvider = context.read<AuthProvider>();
    final provider = context.read<TransactionProvider>();
    final category = _selectedCategory;
    final amount = _parseAmount(_amountController.text);

    if (category == null) {
      _showMessage('Vui lòng chọn hạng mục');
      return;
    }

    if (amount == null || amount <= 0) {
      _showMessage('Vui lòng nhập số tiền hợp lệ');
      return;
    }

    final model = TransactionModel(
      id: _initialTransaction?.id,
      userId: authProvider.currentUserId ?? _initialTransaction?.userId ?? 1,
      categoryId: category.id!,
      type: _type,
      amount: amount,
      date: _toIsoDate(_dateController.text.trim()),
      address: _addressController.text.trim(),
      note: _noteController.text.trim(),
    );

    final success = _initialTransaction == null
        ? await provider.addTransaction(model)
        : await provider.updateTransaction(model);

    if (!mounted) return;
    if (success) {
      Navigator.pop(context, true);
      return;
    }

    _showMessage(provider.errorMessage ?? 'Không thể lưu ghi chép');
  }

  Future<void> _delete() async {
    final provider = context.read<TransactionProvider>();
    final id = _initialTransaction?.id;
    if (id == null) return;

    final success = await provider.deleteTransaction(id);
    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      return;
    }

    _showMessage(provider.errorMessage ?? 'Không thể xóa ghi chép');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final categories = provider.categories;

    if (_selectedCategory == null && categories.isNotEmpty) {
      _selectedCategory = _initialTransaction == null
          ? categories.first
          : categories.cast<CategoryModel?>().firstWhere(
                (item) => item?.id == _initialTransaction!.categoryId,
                orElse: () => categories.first,
              );
    }

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.25),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final popupWidth = constraints.maxWidth > 700
                ? 520.0
                : (constraints.maxWidth - 40).clamp(320.0, 420.0);

            return Center(
              child: Container(
            width: popupWidth,
            constraints: BoxConstraints(maxHeight: constraints.maxHeight - 40),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: provider.isLoading && categories.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 14, 12),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded),
                              color: const Color(0xFF163C3C),
                            ),
                            Expanded(
                              child: Text(
                                _initialTransaction == null
                                    ? 'Tạo Giao Dịch'
                                    : 'Cập Nhật Giao Dịch',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF113939),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(22, 6, 22, 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Phân Loại'),
                              DropdownButtonFormField<String>(
                                initialValue: _type,
                                decoration: _inputDecoration(),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'income',
                                    child: Text('Thu'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'expense',
                                    child: Text('Chi'),
                                  ),
                                ],
                                onChanged: (value) async {
                                  if (value == null) return;
                                  setState(() {
                                    _type = value;
                                    _selectedCategory = null;
                                  });
                                  await context
                                      .read<TransactionProvider>()
                                      .loadCategories(type: value);
                                },
                              ),
                              const SizedBox(height: 12),
                              _label('Hạng Mục'),
                              DropdownButtonFormField<CategoryModel>(
                                initialValue:
                                    categories.contains(_selectedCategory)
                                    ? _selectedCategory
                                    : (categories.isEmpty
                                          ? null
                                          : categories.first),
                                decoration: _inputDecoration(),
                                items: categories
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: Text(item.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              _label('Số Tiền'),
                              TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration().copyWith(
                                  hintText: '213,900',
                                ),
                              ),
                              const SizedBox(height: 12),
                              _label('Ngày'),
                              TextField(
                                controller: _dateController,
                                readOnly: true,
                                onTap: _pickDate,
                                decoration: _inputDecoration().copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: _pickDate,
                                    icon: const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _label('Địa Chỉ'),
                              TextField(
                                controller: _addressController,
                                decoration: _inputDecoration().copyWith(
                                  hintText: 'Siêu Thị Đức Thành',
                                ),
                              ),
                              const SizedBox(height: 12),
                              _label('Ghi Chú'),
                              TextField(
                                controller: _noteController,
                                maxLines: 3,
                                decoration: _inputDecoration().copyWith(
                                  hintText: 'Nhập ghi chú ngắn',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  if (_initialTransaction != null) ...[
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            provider.isLoading ? null : _delete,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                        ),
                                        child: const Text('Xóa'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed:
                                          provider.isLoading ? null : _save,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primary,
                                        foregroundColor:
                                            const Color(0xFF163C3C),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: Text(
                                        provider.isLoading
                                            ? 'Đang xử lý...'
                                            : (_initialTransaction == null
                                                  ? 'Khởi Tạo'
                                                  : 'Cập Nhật'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: fieldBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF113939),
        ),
      ),
    );
  }
}
