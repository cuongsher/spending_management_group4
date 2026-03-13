class CategoryModel {
  final int? id;
  final int userId;
  final String name;
  final String type;
  final String description;

  CategoryModel({
    this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'description': description,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      type: map['type'],
      description: map['description'],
    );
  }
}