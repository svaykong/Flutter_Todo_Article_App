class LoginResModel {
  const LoginResModel({
    required this.token,
  });

  final String token;

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(token: json['token']);
}
