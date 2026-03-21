import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../provider/provider_ngan/transactionProvider.dart';
import '../../database/model1/TransactionModel.dart';
import 'transaction_repositories.dart';
 // Đảm bảo đường dẫn này đúng với file provider.dart của bạn

// Lớp Notifier để quản lý logic thay đổi dữ liệu
class TransactionNotifier extends StateNotifier<List<Transaction>> {
  final TransactionRepository repo;

  TransactionNotifier(this.repo) : super([]) {
    // Tự động load dữ liệu khi khởi tạo
    load();
  }

  Future<void> load() async {
    try {
      state = await repo.getAll();
    } catch (e) {
      // Có thể xử lý lỗi ở đây nếu cần
      state = [];
    }
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

// Provider này nên được khai báo một nơi (đã có trong provider.dart,
// nhưng nếu bạn muốn để ở đây thì hãy comment bên kia lại để tránh trùng tên)
final transactionProvider =
StateNotifierProvider<TransactionNotifier, List<Transaction>>((ref) {
  final repo = ref.watch(transactionRepoProvider);
  return TransactionNotifier(repo);
});