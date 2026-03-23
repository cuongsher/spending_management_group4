class AssetModel {
  final int? id;
  final int userId;
  final String assetName;
  final double amount;
  final String description;
  final String purchaseDate;

  AssetModel({
    this.id,
    required this.userId,
    required this.assetName,
    required this.amount,
    required this.description,
    required this.purchaseDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'asset_name': assetName,
      'amount': amount,
      'description': description,
      'purchase_date': purchaseDate,
    };
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map['id'],
      userId: map['user_id'],
      assetName: map['asset_name'],
      amount: map['amount'],
      description: map['description'],
      purchaseDate: (map['purchase_date'] as String?) ?? '',
    );
  }
}
