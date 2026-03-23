import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/CategoryModel.dart';
import '../../router/app_router.dart';
import '../provider/customize_provider.dart';
import '../widgets/app_bottom_nav.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  String _keyword = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomizeProvider>().loadCategories(type: 'expense');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomizeProvider>();
    final filteredCategories = provider.categories.where((item) {
      final keyword = _keyword.trim().toLowerCase();
      if (keyword.isEmpty) return true;
      return item.name.toLowerCase().contains(keyword) ||
          item.description.toLowerCase().contains(keyword);
    }).toList();

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
                    _topBar('Hạng Mục Thu / Chi'),
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
                            Row(
                              children: [
                                Expanded(
                                  child: _typeTile(
                                    label: 'Mục Thu',
                                    selected:
                                        provider.selectedCategoryType ==
                                        'income',
                                    onTap: () => context
                                        .read<CustomizeProvider>()
                                        .loadCategories(type: 'income'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _typeTile(
                                    label: 'Mục Chi',
                                    selected:
                                        provider.selectedCategoryType ==
                                        'expense',
                                    onTap: () => context
                                        .read<CustomizeProvider>()
                                        .loadCategories(type: 'expense'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  _keyword = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Tìm kiếm...',
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Expanded(
                              child: ListView.separated(
                                itemCount: filteredCategories.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final item = filteredCategories[index];
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Color(0xFF4D94FF),
                                          child: Icon(
                                            Icons.category_outlined,
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
                                                item.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(item.description),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _openCategoryDialog(
                                            context,
                                            provider,
                                            initialItem: item,
                                          ),
                                          icon: const Icon(Icons.edit_outlined),
                                          color: const Color(0xFF163C3C),
                                        ),
                                        IconButton(
                                          onPressed: () => _deleteCategory(
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
                                    _openCategoryDialog(context, provider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: const Color(0xFF163C3C),
                                ),
                                child: const Text('Thêm Hạng Mục'),
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

  Future<void> _openCategoryDialog(
    BuildContext context,
    CustomizeProvider provider, {
    CategoryModel? initialItem,
  }) async {
    final nameController = TextEditingController(text: initialItem?.name ?? '');
    final descriptionController = TextEditingController(
      text: initialItem?.description ?? '',
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(initialItem == null ? 'Thêm Hạng Mục' : 'Sửa Hạng Mục'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
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

    final success = await provider.saveCategory(
      CategoryModel(
        id: initialItem?.id,
        userId: initialItem?.userId ?? 1,
        name: nameController.text.trim(),
        type: provider.selectedCategoryType,
        description: descriptionController.text.trim(),
      ),
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Không thể lưu hạng mục')),
      );
    }
  }

  Future<void> _deleteCategory(
    BuildContext context,
    CustomizeProvider provider,
    CategoryModel item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa hạng mục'),
          content: Text('Bạn có chắc muốn xóa "${item.name}" không?'),
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
    await provider.deleteCategory(item.id!);
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

  Widget _typeTile({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1D6FFF)
              : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF1D6FFF),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
