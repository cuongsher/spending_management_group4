import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/AssetModel.dart';
import '../../router/app_router.dart';
import '../provider/customize_provider.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_secondary_shell.dart';

class AssetListScreen extends StatefulWidget {
  const AssetListScreen({super.key});

  @override
  State<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends State<AssetListScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomizeProvider>().loadAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomizeProvider>();

    return AppSecondaryShell(
      primaryColor: primary,
      header: _topBar('Quản Lý Tài Sản'),
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
              child: ListView.separated(
                itemCount: provider.assets.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = provider.assets[index];
                  return _assetTile(context, provider, item);
                },
              ),
            ),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () => _openAssetDialog(context, provider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: const Color(0xFF163C3C),
                ),
                child: const Text('Thêm Tài Sản'),
              ),
            ),
            const SizedBox(height: 12),
            const AppBottomNav(currentRoute: AppRouter.customize),
          ],
        ),
      ),
    );
  }

  Widget _assetTile(
    BuildContext context,
    CustomizeProvider provider,
    AssetModel item,
  ) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, AppRouter.assetDetail, arguments: item),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFF79AFFF),
              child: Icon(Icons.savings_outlined, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.assetName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(item.description),
                  if (item.purchaseDate.isNotEmpty)
                    Text(
                      'Ngày mua: ${item.purchaseDate}',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              item.amount.toStringAsFixed(2),
              style: const TextStyle(
                color: Color(0xFF16C8A0),
                fontWeight: FontWeight.w800,
              ),
            ),
            IconButton(
              onPressed: () =>
                  _openAssetDialog(context, provider, initialItem: item),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () => _deleteAsset(context, provider, item),
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAssetDialog(
    BuildContext context,
    CustomizeProvider provider, {
    AssetModel? initialItem,
  }) async {
    final nameController = TextEditingController(text: initialItem?.assetName ?? '');
    final amountController = TextEditingController(
      text: initialItem?.amount.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: initialItem?.description ?? '',
    );
    final purchaseDateController = TextEditingController(
      text: initialItem?.purchaseDate.isNotEmpty == true
          ? initialItem!.purchaseDate
          : '15/10/2024',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(initialItem == null ? 'Thêm Tài Sản' : 'Sửa Tài Sản'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên tài sản'),
              ),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Số tiền'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
              TextField(
                controller: purchaseDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Ngày mua',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: DateTime(2024, 10, 15),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked == null) return;
                      final day = picked.day.toString().padLeft(2, '0');
                      final month = picked.month.toString().padLeft(2, '0');
                      purchaseDateController.text = '$day/$month/${picked.year}';
                    },
                    icon: const Icon(Icons.calendar_today_outlined),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );

    if (saved != true || !mounted) return;

    final success = await provider.saveAsset(
      AssetModel(
        id: initialItem?.id,
        userId: initialItem?.userId ?? 1,
        assetName: nameController.text.trim(),
        amount: double.tryParse(amountController.text.trim()) ?? 0,
        description: descriptionController.text.trim(),
        purchaseDate: purchaseDateController.text.trim(),
      ),
    );

    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Không thể lưu tài sản')),
      );
    }
  }

  Future<void> _deleteAsset(
    BuildContext context,
    CustomizeProvider provider,
    AssetModel item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa tài sản'),
          content: Text('Bạn có chắc muốn xóa "${item.assetName}" không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted || item.id == null) return;
    await provider.deleteAsset(item.id!);
  }

  Widget _topBar(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 20, 18),
      child: Row(
        children: [
          const BackButton(color: Colors.white),
          Expanded(
            child: Text(
              title,
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
    );
  }
}
