class PasswordResetModel {
  final int? id;
  final int userId;
  final String otpCode;
  final String expiredAt;
  final String status;
  final String createdAt;

  PasswordResetModel({
    this.id,
    required this.userId,
    required this.otpCode,
    required this.expiredAt,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'otp_code': otpCode,
      'expired_at': expiredAt,
      'status': status,
      'created_at': createdAt,
    };
  }

  factory PasswordResetModel.fromMap(Map<String, dynamic> map) {
    return PasswordResetModel(
      id: map['id'],
      userId: map['user_id'],
      otpCode: map['otp_code'],
      expiredAt: map['expired_at'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }
}