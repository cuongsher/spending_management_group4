/// Phân loại giao dịch: Thu / Chi
enum TransactionType {
  income,
  expense,
}

/// Model Giao Dịch 
class Transaction {
  final String id;
  final TransactionType type;
  final String category;
  final int amount; // đơn vị: VND (int để tránh lỗi số thực)
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  /// Dùng khi edit transaction
  Transaction copyWith({
    String? id,
    TransactionType? type,
    String? category,
    int? amount,
    DateTime? date,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/* Vì sao có copyWith()?

Khi sửa giao dịch:

final updated = oldTx.copyWith(amount: 300000);


Không phá object cũ */ 
