class UserModel {
  final String token;
  final String email;
  final String fullName;
  final String phoneNumber;

  UserModel({
    required this.token,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'],
      email: json['email'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
