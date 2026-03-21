import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/report/controller_edit_transaction.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../provider/provider_ngan/transactionProvider.dart';
import '../widget_ngan/widgets_ghi_chep.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  final Transaction transaction;
  const EditTransactionScreen({super.key, required this.transaction});

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  late final EditTransactionController _controller;

  late TransactionType _type;
  late DateTime _date;
  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final repo = ref.read(transactionRepoProvider);
    _controller = EditTransactionController(repo, widget.transaction);

    final tx = widget.transaction;
    _type = tx.type;
    _date = tx.date;
    _categoryCtrl.text = tx.category;
    _amountCtrl.text = tx.amount.toString();
    _noteCtrl.text = tx.note ?? '';
  }

  @override
  void dispose() {
    _categoryCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _update() async {
    final amount =
        int.tryParse(
          _amountCtrl.text.replaceAll('.', '').replaceAll(',', ''),
        ) ??
        0;
    final success = await _controller.update(
      type: _type,
      category: _categoryCtrl.text,
      amount: amount,
      date: _date,
      note: _noteCtrl.text,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pop(context, 'updated');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_controller.error ?? 'Có lỗi')));
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa giao dịch'),
        content: const Text('Bạn có chắc muốn xóa không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _controller.delete();
      if (!mounted) return;
      Navigator.pop(context, 'deleted');
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          const GhiChepHeader(title: 'Sửa Ghi Chép'),
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (_, __) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldLabel('Phân Loại'),
                    DropdownField(
                      value: _type == TransactionType.expense
                          ? 'Khoản Chi'
                          : 'Khoản Thu',
                      items: const ['Khoản Thu', 'Khoản Chi'],
                      onChanged: (v) => setState(() {
                        _type = v == 'Khoản Thu'
                            ? TransactionType.income
                            : TransactionType.expense;
                      }),
                    ),
                    const SizedBox(height: 14),
                    FieldLabel('Hạng Mục'),
                    InputField(
                      controller: _categoryCtrl,
                      hint: 'vd: Ăn Uống, Mua Sắm, Lương...',
                    ),
                    const SizedBox(height: 14),
                    FieldLabel('Số Tiền'),
                    InputField(
                      controller: _amountCtrl,
                      hint: 'vd: 150000',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    FieldLabel('Ngày'),
                    DateField(date: _date, onTap: _pickDate, fmt: _fmtDate),
                    const SizedBox(height: 14),
                    FieldLabel('Ghi Chú'),
                    InputField(
                      controller: _noteCtrl,
                      hint: 'vd: Siêu thị, Grab, Tiền điện...',
                    ),
                  ],
                ),
              ),
            ),
          ),
          BottomActionBar(
            onDelete: _delete,
            onCamera: () {},
            onSave: _controller.isLoading ? null : _update,
            isLoading: _controller.isLoading,
          ),
        ],
      ),
    );
  }
}
