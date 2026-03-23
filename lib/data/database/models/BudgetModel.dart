class BudgetModel {
  final int? id;
  final int userId;
  final int categoryId;
  final String budgetName;
  final double amount;
  final String startDate;
  final String endDate;
  final String repeatType;

  BudgetModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.budgetName,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.repeatType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'budget_name': budgetName,
      'amount': amount,
      'start_date': startDate,
      'end_date': endDate,
      'repeat_type': repeatType,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      userId: map['user_id'],
      categoryId: map['category_id'],
      budgetName: map['budget_name'],
      amount: map['amount'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      repeatType: map['repeat_type'],
    );
  }
}