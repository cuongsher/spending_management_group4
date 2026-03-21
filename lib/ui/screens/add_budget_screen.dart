import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/BudgetModel.dart';
import '../../router/app_router.dart';
import '../provider/budget_provider.dart';
import '../widgets/app_bottom_nav.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  final List<_BudgetCategoryOption> _categories = const [
    _BudgetCategoryOption(id: 3, label: 'Ăn Uống'),
    _BudgetCategoryOption(id: 4, label: 'Mua Sắm'),
    _BudgetCategoryOption(id: 5, label: 'Thuê Nhà'),
    _BudgetCategoryOption(id: 6, label: 'Giải Trí'),
  ];
  final List<String> _repeatOptions = const [
    'Mỗi Tháng',
    'Mỗi Ngày',
    'Mỗi Năm',
  ];

  late _BudgetCategoryOption _selectedCategory;
  String _selectedRepeat = 'Mỗi Tháng';

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
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
    controller.text = '$day/$month/$year';
    setState(() {});
  }

  Future<void> _save() async {
    final provider = context.read<BudgetProvider>();

    final budget = BudgetModel(
      userId: 1,
      categoryId: _selectedCategory.id,
      budgetName: _nameController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      startDate: _startController.text.trim(),
      endDate: _endController.text.trim(),
      repeatType: _selectedRepeat.toLowerCase(),
    );

    final success = await provider.addBudget(budget);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'Không thể lưu hạn mức'),
      ),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _amountController.clear();
    _startController.clear();
    _endController.clear();
    setState(() {
      _selectedCategory = _categories.first;
      _selectedRepeat = _repeatOptions.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();

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
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            color: Colors.white,
                          ),
                          const Expanded(
                            child: Text(
                              'Thêm Hạn Mức',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
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
                        padding: const EdgeInsets.fromLTRB(24, 26, 24, 12),
                        decoration: const BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Hạng Mục Chi'),
                                    _buildDropdown<_BudgetCategoryOption>(
                                      value: _selectedCategory,
                                      items: _categories,
                                      labelBuilder: (item) => item.label,
                                      onChanged: (value) {
                                        if (value == null) return;
                                        setState(() {
                                          _selectedCategory = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel('Số Tiền'),
                                    _buildTextField(
                                      controller: _amountController,
                                      hint: '87.32 VND',
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel('Tên Hạn Mức'),
                                    _buildTextField(
                                      controller: _nameController,
                                      hint: 'Ăn Đêm',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabel('Ngày Bắt Đầu'),
                                    _buildDateField(_startController),
                                    const SizedBox(height: 16),
                                    _buildLabel('Ngày Kết Thúc'),
                                    _buildDateField(_endController),
                                    const SizedBox(height: 16),
                                    _buildLabel('Lặp Lại'),
                                    _buildDropdown<String>(
                                      value: _selectedRepeat,
                                      items: _repeatOptions,
                                      labelBuilder: (item) => item,
                                      onChanged: (value) {
                                        if (value == null) return;
                                        setState(() {
                                          _selectedRepeat = value;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _clearForm,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                            ),
                                            child: const Text('Xóa'),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed:
                                                provider.isLoading ? null : _save,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primary,
                                              foregroundColor:
                                                  const Color(0xFF123E3E),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
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
                            const SizedBox(height: 10),
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

  Widget _buildLabel(String text) {
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
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
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDate(controller),
      decoration: InputDecoration(
        hintText: '15/10/2024',
        filled: true,
        fillColor: const Color(0xFFDFF1E1),
        suffixIcon: IconButton(
          onPressed: () => _pickDate(controller),
          icon: const Icon(Icons.calendar_today_rounded, size: 18),
        ),
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
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T item) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
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
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(labelBuilder(item)),
            ),
          )
          .toList(),
    );
  }
}

class _BudgetCategoryOption {
  const _BudgetCategoryOption({required this.id, required this.label});

  final int id;
  final String label;
}
