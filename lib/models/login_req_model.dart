import 'package:equatable/equatable.dart';

class LoginReqModel extends Equatable {
  const LoginReqModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }

  @override
  List<Object?> get props => [email, password];
}
