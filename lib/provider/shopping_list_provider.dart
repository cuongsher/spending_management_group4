import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/models/ShoppingListModel.dart';
import '../data/repository/shopping_list_repository.dart';

final shoppingRepositoryProvider =
Provider((ref) => ShoppingListRepository());

final shoppingListProvider =
StateNotifierProvider<ShoppingListNotifier, List<ShoppingListModel>>(
      (ref) => ShoppingListNotifier(ref),
);

class ShoppingListNotifier extends StateNotifier<List<ShoppingListModel>> {

  final Ref ref;

  ShoppingListNotifier(this.ref) : super([]) {
    loadShoppingItems();
  }

  Future<void> loadShoppingItems() async {

    final repo = ref.read(shoppingRepositoryProvider);

    state = await repo.getShoppingItems();
  }
}