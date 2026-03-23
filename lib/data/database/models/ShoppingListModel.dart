class ShoppingListModel {
  final int? id;
  final int userId;
  final String itemName;
  final double estimatedPrice;
  final String status;

  ShoppingListModel({
    this.id,
    required this.userId,
    required this.itemName,
    required this.estimatedPrice,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'item_name': itemName,
      'estimated_price': estimatedPrice,
      'status': status,
    };
  }

  factory ShoppingListModel.fromMap(Map<String, dynamic> map) {
    return ShoppingListModel(
      id: map['id'],
      userId: map['user_id'],
      itemName: map['item_name'],
      estimatedPrice: map['estimated_price'],
      status: map['status'],
    );
  }
}