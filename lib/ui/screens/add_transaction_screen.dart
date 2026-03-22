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
  static const Color lightBg = Color(0xFFEAF6EE);

  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();

  String _type = 'expense';
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _dateController.text = _todayText();
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
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();
    return '$day/$month/$year';
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final day = picked.day.toString().padLeft(2, '0');
    final month = picked.month.toString().padLeft(2, '0');
    final year = picked.year.toString();
    _dateController.text = '$day/$month/$year';
    setState(() {});
  }

  Future<void> _save() async {
    final authProvider = context.read<AuthProvider>();
    final provider = context.read<TransactionProvider>();
    final category = _selectedCategory;
    final amount = _parseAmount(_amountController.text);

    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn hạng mục')),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
      );
      return;
    }

    final success = await provider.addTransaction(
      TransactionModel(
        userId: authProvider.currentUserId ?? 1,
        categoryId: category.id!,
        type: _type,
        amount: amount,
        date: _toIsoDate(_dateController.text.trim()),
        address: _addressController.text.trim(),
        note: _noteController.text.trim(),
      ),
    );

    if (!mounted) return;
    if (success) {
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Không thể lưu ghi chép'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionProvider>();
    final categories = provider.categories;
    if (_selectedCategory == null && categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }

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
                          const Expanded(
                            child: Text(
                              'Thêm Ghi Chép',
                              textAlign: TextAlign.center,
                              style: TextStyle(
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
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                        decoration: const BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: provider.isLoading && categories.isEmpty
                            ? const Center(child: CircularProgressIndicator())
                            : SingleChildScrollView(
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
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                              foregroundColor:
                                                  const Color(0xFF163C3C),
                                            ),
                                            child: Text(
                                              provider.isLoading
                                                  ? 'Đang lưu...'
                                                  : 'Lưu',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF133C3C),
        ),
      ),
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
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: primary),
      ),
    );
  }
}
