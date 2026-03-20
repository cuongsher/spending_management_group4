class TransactionModel {
  final int? id;
  final int userId;
  final int categoryId;
  final String type;
  final double amount;
  final String date;
  final String address;
  final String note;

  TransactionModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.date,
    required this.address,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'type': type,
      'amount': amount,
      'date': date,
      'address': address,
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'],
      categoryId: map['category_id'],
      type: map['type'],
      amount: map['amount'],
      date: map['date'],
      address: map['address'],
      note: map['note'],
    );
  }
}