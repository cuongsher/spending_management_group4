class NotificationModel {
  final int? id;
  final int userId;
  final String title;
  final String content;
  final String createdAt;
  final String status;

  NotificationModel({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'created_at': createdAt,
      'status': status,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      content: map['content'],
      createdAt: map['created_at'],
      status: map['status'],
    );
  }
}