enum TransactionType { income, expense }

class Transaction {
  final String id;
  final TransactionType type;
  final String category;
  final int amount;
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromMap(Map<String, Object?> map) {
    return Transaction(
      id: map['id'] as String,
      type: TransactionType.values
          .firstWhere((e) => e.name == map['type']),
      category: map['category'] as String,
      amount: (map['amount'] as num).toInt(),
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'type': type.name,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

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