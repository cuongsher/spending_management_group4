import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/BudgetModel.dart';
import '../../data/database/models/CategoryModel.dart';
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

  final List<String> _repeatOptions = const [
    'Mỗi Tháng',
    'Mỗi Ngày',
    'Mỗi Năm',
  ];

  CategoryModel? _selectedCategory;
  String _selectedRepeat = 'Mỗi Tháng';
  BudgetModel? _initialBudget;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _initialBudget = ModalRoute.of(context)?.settings.arguments as BudgetModel?;
    final provider = context.read<BudgetProvider>();
    provider.loadBudgets();
    if (_initialBudget != null) {
      _nameController.text = _initialBudget!.budgetName;
      _amountController.text = _initialBudget!.amount.toString();
      _startController.text = _initialBudget!.startDate;
      _endController.text = _initialBudget!.endDate;
      _selectedRepeat = _toRepeatLabel(_initialBudget!.repeatType);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  String _toRepeatLabel(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('day') || lower.contains('ngày')) return 'Mỗi Ngày';
    if (lower.contains('year') || lower.contains('năm')) return 'Mỗi Năm';
    return 'Mỗi Tháng';
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
    final category = _selectedCategory;
    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn hạng mục chi')),
      );
      return;
    }

    final budget = BudgetModel(
      id: _initialBudget?.id,
      userId: _initialBudget?.userId ?? 1,
      categoryId: category.id!,
      budgetName: _nameController.text.trim(),
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      startDate: _startController.text.trim(),
      endDate: _endController.text.trim(),
      repeatType: _selectedRepeat.toLowerCase(),
    );

    final success = _initialBudget == null
        ? await provider.addBudget(budget)
        : await provider.updateBudget(budget);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(provider.errorMessage ?? 'Không thể lưu hạn mức')),
    );
  }

  void _clearForm() {
    _nameController.clear();
    _amountController.clear();
    _startController.clear();
    _endController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedRepeat = _repeatOptions.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();
    final categories = provider.expenseCategories;
    if (_selectedCategory == null && categories.isNotEmpty) {
      _selectedCategory = _initialBudget == null
          ? categories.first
          : categories.cast<CategoryModel?>().firstWhere(
                (item) => item?.id == _initialBudget!.categoryId,
                orElse: () => categories.first,
              );
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
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              _initialBudget == null ? 'Thêm Hạn Mức' : 'Cập Nhật Hạn Mức',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
                                    DropdownButtonFormField<CategoryModel>(
                                      initialValue: categories.contains(_selectedCategory)
                                          ? _selectedCategory
                                          : null,
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
                                    DropdownButtonFormField<String>(
                                      initialValue: _selectedRepeat,
                                      onChanged: (value) {
                                        if (value == null) return;
                                        setState(() {
                                          _selectedRepeat = value;
                                        });
                                      },
                                      decoration: _inputDecoration(),
                                      items: _repeatOptions
                                          .map(
                                            (item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(item),
                                            ),
                                          )
                                          .toList(),
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
                                            child: const Text('Xóa Form'),
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
      decoration: _inputDecoration().copyWith(hintText: hint),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDate(controller),
      decoration: _inputDecoration().copyWith(
        hintText: '15/10/2024',
        suffixIcon: IconButton(
          onPressed: () => _pickDate(controller),
          icon: const Icon(Icons.calendar_today_rounded, size: 18),
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
