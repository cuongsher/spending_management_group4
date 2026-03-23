class UserModel {
  final int? id;
  final String fullName;
  final String email;
  final String phone;
  final String birthDate;
  final String password;
  final String createdAt;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'birth_date': birthDate,
      'password': password,
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['full_name'],
      email: map['email'],
      phone: map['phone'],
      birthDate: map['birth_date'],
      password: map['password'],
      createdAt: map['created_at'],
    );
  }
}