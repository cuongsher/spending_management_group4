import 'package:flutter/material.dart';
// ignore: unused_import
import '../../../transactions/data/repositories/transaction_repo_provider.dart';
import '../../../../app/app_scope.dart';
import '../../domain/models/transaction.dart';
import 'edit_transaction_controller.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late final EditTransactionController _controller;

  late TransactionType _type;
  late DateTime _date;

  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = EditTransactionController(
      AppScope.transactionRepo,
      widget.transaction,
    );

    final tx = widget.transaction;
    _type = tx.type;
    _date = tx.date;
    _categoryCtrl.text = tx.category;
    _amountCtrl.text = tx.amount.toString();
    _noteCtrl.text = tx.note ?? '';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _update() async {
    final amount = int.tryParse(_amountCtrl.text) ?? 0;

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
            child: const Text('Xóa'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa ghi chép'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListenableBuilder(
          listenable: _controller,
          builder: (_, __) {
            return Column(
              children: [
                DropdownButtonFormField<TransactionType>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(
                      value: TransactionType.expense,
                      child: Text('Chi tiêu'),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.income,
                      child: Text('Thu nhập'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _type = v!),
                ),
                TextField(
                  controller: _categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Hạng mục'),
                ),
                TextField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Số tiền'),
                ),
                Row(
                  children: [
                    Text('Ngày: ${_date.day}/${_date.month}/${_date.year}'),
                    const Spacer(),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Chọn ngày'),
                    ),
                  ],
                ),
                TextField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(labelText: 'Ghi chú'),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _controller.isLoading ? null : _update,
                    child: const Text('Cập nhật'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
