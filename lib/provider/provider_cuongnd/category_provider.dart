import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/model1/CategoryModel.dart';
import '../../data/repository/repository_cuongnd/category_repository.dart';

final categoryRepositoryProvider =
Provider((ref) => CategoryRepository());

final categoryProvider =
StateNotifierProvider<CategoryNotifier, List<CategoryModel>>(
      (ref) => CategoryNotifier(ref),
);

class CategoryNotifier extends StateNotifier<List<CategoryModel>> {

  final Ref ref;

  CategoryNotifier(this.ref) : super([]) {
    loadCategories();
  }

  Future<void> loadCategories() async {

    final repo = ref.read(categoryRepositoryProvider);

    state = await repo.getCategories();
  }
}