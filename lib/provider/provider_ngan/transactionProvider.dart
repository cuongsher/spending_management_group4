import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../data/database/database.dart';
import '../../data/repository/repository_ngan/transaction_repo_sqlite.dart';
import '../../data/repository/repository_ngan/transaction_repositories.dart';


/// Provider khởi tạo Database
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  return await AppDatabase.open();
});

/// Provider cung cấp Repository (Dùng Sqlite làm mặc định)
final transactionRepoProvider = Provider<TransactionRepository>((ref) {
  final dbAsync = ref.watch(databaseProvider);

  return dbAsync.when(
    data: (db) => TransactionRepoSqlite(db),
    loading: () => throw Exception("Cơ sở dữ liệu đang tải..."),
    error: (e, _) => throw Exception("Lỗi DB: $e"),
  );
});

/// StateNotifier quản lý danh sách giao dịch cho UI
class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final TransactionRepository repo;

  TransactionNotifier(this.repo) : super([]) {
    load(); // Tự động load khi khởi tạo
  }

  Future<void> load() async {
    state = await repo.getAll();
  }

  Future<void> add(Transaction t) async {
    await repo.add(t);
    await load();
  }

  Future<void> delete(String id) async {
    await repo.delete(id);
    await load();
  }
}

/// Provider để UI gọi dùng: ref.watch(transactionProvider)
final transactionProvider =
StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  final repo = ref.watch(transactionRepoProvider);
  return TransactionNotifier(repo);
});