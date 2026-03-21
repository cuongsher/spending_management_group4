import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/report/controller_add_transaction.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../provider/provider_ngan/transactionProvider.dart';
import '../widget_ngan/widgets_ghi_chep.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  static const routeName = '/add-transaction';
  final VoidCallback? onSaved;
  const AddTransactionScreen({super.key, this.onSaved});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late final AddTransactionController _controller;

  TransactionType _type = TransactionType.expense;
  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  final List<ScannedItem> _scannedItems = [];

  @override
  void initState() {
    super.initState();
    final repo = ref.read(transactionRepoProvider);
    _controller = AddTransactionController(repo);
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

  Future<void> _submit() async {
    final amount = int.tryParse(
        _amountCtrl.text.replaceAll('.', '').replaceAll(',', '')) ??
        0;
    final success = await _controller.submit(
      type: _type,
      category: _categoryCtrl.text,
      amount: amount,
      date: _date,
      note: _noteCtrl.text,
    );
    if (!mounted) return;
    if (success) {
      if (widget.onSaved != null) {
        // Dùng như tab: reset form thay vì pop
        widget.onSaved!();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu giao dịch')),
        );
      } else {
        Navigator.of(context).pop('created');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.error ?? 'Có lỗi xảy ra')),
      );
    }
  }

  void _onScanCamera() {
    setState(() {
      _scannedItems.add(ScannedItem(
        name: 'Sản phẩm ${_scannedItems.length + 1}',
        unitPrice: 32000,
        category: 'Thực phẩm',
        qty: 1.0,
      ));
    });
  }

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: Column(
        children: [
          const GhiChepHeader(title: 'Thêm Ghi Chép'),
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
                      value: _type == TransactionType.expense ? 'Khoản Chi' : 'Khoản Thu',
                      items: const ['Khoản Thu', 'Khoản Chi'],
                      onChanged: (v) => setState(() {
                        _type = v == 'Khoản Thu'
                            ? TransactionType.income
                            : TransactionType.expense;
                      }),
                    ),
                    const SizedBox(height: 14),
                    FieldLabel('Hạng Mục'),
                    InputField(controller: _categoryCtrl, hint: 'vd: Ăn Uống, Mua Sắm, Lương...'),
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
                    InputField(controller: _noteCtrl, hint: 'vd: Siêu thị, Grab, Tiền điện...'),
                    const SizedBox(height: 16),
                    ..._scannedItems.map((item) => ScannedItemTile(item: item)),
                  ],
                ),
              ),
            ),
          ),
          BottomActionBar(
            onDelete: widget.onSaved != null
                ? () => setState(() {
              _categoryCtrl.clear();
              _amountCtrl.clear();
              _noteCtrl.clear();
              _date = DateTime.now();
              _type = TransactionType.expense;
              _scannedItems.clear();
            })
                : () => Navigator.of(context).pop(),
            onCamera: _onScanCamera,
            onSave: _controller.isLoading ? null : _submit,
            isLoading: _controller.isLoading,
          ),
        ],
      ),
    );
  }
}
