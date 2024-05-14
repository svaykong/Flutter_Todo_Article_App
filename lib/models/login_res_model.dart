import 'package:equatable/equatable.dart';

class LoginResModel extends Equatable {
  const LoginResModel({
    required this.token,
  });

  final String token;

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(token: json['token']);

  @override
  List<Object?> get props => [token];
}
