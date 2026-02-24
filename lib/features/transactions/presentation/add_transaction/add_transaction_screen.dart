import 'package:flutter/material.dart';
// ignore: unused_import
import '../../../transactions/data/repositories/transaction_repo_provider.dart';
import '../../../../app/app_scope.dart';
import '../../domain/models/transaction.dart';
import 'add_transaction_controller.dart';

class AddTransactionScreen extends StatefulWidget {
  static const routeName = '/add-transaction';
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late final AddTransactionController _controller;

  TransactionType _type = TransactionType.expense;
  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = AddTransactionController(AppScope.transactionRepo);
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
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    final amount = int.tryParse(_amountCtrl.text) ?? 0;

    final success = await _controller.submit(
      type: _type,
      category: _categoryCtrl.text,
      amount: amount,
      date: _date,
      note: _noteCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop('created');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.error ?? 'Có lỗi xảy ra')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _HeaderGreen(
            title: 'Thêm Ghi Chép',
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListenableBuilder(
                listenable: _controller,
                builder: (_, __) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
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
                                    onChanged: (v) {
                                      if (v == null) return;
                                      setState(() => _type = v);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Phân loại',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _categoryCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Hạng mục',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _amountCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Số tiền',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text(
                                        'Ngày: ${_date.day}/${_date.month}/${_date.year}',
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: _pickDate,
                                        child: const Text('Chọn ngày'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _noteCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Ghi chú / Địa chỉ',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _controller.isLoading ? null : _submit,
                          child: _controller.isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Lưu'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ✅ ĐÓNG CLASS _AddTransactionScreenState Ở ĐÂY

// ✅ DÁN _HeaderGreen Ở NGOÀI CLASS
class _HeaderGreen extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _HeaderGreen({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/*Ý C DONE khi bạn test được:

 Mở màn Ghi chép

 Nhập dữ liệu

 Bấm Lưu

 Không lỗi

 Navigator.pop('created') chạy

➡️ Lúc này bạn đã có Function Ghi chép hoàn chỉnh end-to-end:

UI → Controller → Fake Repo → Done

🚦 Cảnh báo kiến trúc (mentor nhắc trước)

Hiện tại trong Screen bạn tạo:

TransactionRepoFake()


👉 Cách này OK cho demo.

Sau này bạn sẽ:

inject repo từ App level

dùng Riverpod/DI

👉 Nhưng KHÔNG cần sửa Controller hay Screen logic. */
