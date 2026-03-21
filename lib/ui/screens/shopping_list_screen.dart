import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/ShoppingListModel.dart';
import '../../router/app_router.dart';
import '../provider/customize_provider.dart';
import '../widgets/app_bottom_nav.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomizeProvider>().loadShoppingItems();
    });
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
                    _topBar('Danh Sách Mua Sắm'),
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
                              child: ListView.separated(
                                itemCount: provider.shoppingItems.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  final item = provider.shoppingItems[index];
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.65,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Color(0xFF79AFFF),
                                          child: Icon(
                                            Icons.shopping_bag_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.itemName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                'Giá dự kiến: ${item.estimatedPrice.toStringAsFixed(2)} VND',
                                                style: const TextStyle(
                                                  color: Color(0xFF2377F0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _openShoppingDialog(
                                            context,
                                            provider,
                                            initialItem: item,
                                          ),
                                          icon: const Icon(Icons.edit_outlined),
                                        ),
                                        IconButton(
                                          onPressed: () => _deleteItem(
                                            context,
                                            provider,
                                            item,
                                          ),
                                          icon: const Icon(Icons.delete_outline),
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _openShoppingDialog(context, provider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: const Color(0xFF163C3C),
                                ),
                                child: const Text('Thêm Sản Phẩm'),
                              ),
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

  Future<void> _openShoppingDialog(
    BuildContext context,
    CustomizeProvider provider, {
    ShoppingListModel? initialItem,
  }) async {
    final nameController = TextEditingController(
      text: initialItem?.itemName ?? '',
    );
    final priceController = TextEditingController(
      text: initialItem?.estimatedPrice.toString() ?? '',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(initialItem == null ? 'Thêm Sản Phẩm' : 'Sửa Sản Phẩm'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Giá dự kiến'),
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

    final success = await provider.saveShoppingItem(
      ShoppingListModel(
        id: initialItem?.id,
        userId: initialItem?.userId ?? 1,
        itemName: nameController.text.trim(),
        estimatedPrice: double.tryParse(priceController.text.trim()) ?? 0,
        status: initialItem?.status ?? 'active',
      ),
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Không thể lưu sản phẩm')),
      );
    }
  }

  Future<void> _deleteItem(
    BuildContext context,
    CustomizeProvider provider,
    ShoppingListModel item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa sản phẩm'),
          content: Text('Bạn có chắc muốn xóa "${item.itemName}" không?'),
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
    await provider.deleteShoppingItem(item.id!);
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
