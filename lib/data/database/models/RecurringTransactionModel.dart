class RecurringTransactionModel {
  final int? id;
  final int userId;
  final int categoryId;
  final double amount;
  final String startDate;
  final String repeatCycle;
  final String note;

  RecurringTransactionModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.startDate,
    required this.repeatCycle,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'start_date': startDate,
      'repeat_cycle': repeatCycle,
      'note': note,
    };
  }

  factory RecurringTransactionModel.fromMap(Map<String, dynamic> map) {
    return RecurringTransactionModel(
      id: map['id'],
      userId: map['user_id'],
      categoryId: map['category_id'],
      amount: map['amount'],
      startDate: map['start_date'],
      repeatCycle: map['repeat_cycle'],
      note: map['note'],
    );
  }
}