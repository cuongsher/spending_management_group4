import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/model1/BudgetModel.dart';
import '../../data/repository/repository_cuongnd/budget_repository.dart';

final budgetRepositoryProvider =
Provider((ref) => BudgetRepository());

final budgetProvider =
StateNotifierProvider<BudgetNotifier, List<BudgetModel>>(
      (ref) => BudgetNotifier(ref),
);

class BudgetNotifier extends StateNotifier<List<BudgetModel>> {

  final Ref ref;

  BudgetNotifier(this.ref) : super([]) {
    loadBudgets();
  }

  Future<void> loadBudgets() async {

    final repo = ref.read(budgetRepositoryProvider);

    state = await repo.getBudgets();
  }
}