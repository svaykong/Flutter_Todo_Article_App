import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/logger.dart';
import '../utils/app_exception.dart';
import '../constants/constants.dart';
import '../models/login_req_model.dart';
import '../models/login_res_model.dart';

class AuthenticationService {
  static const jsonHeader = {
    'Content-Type': 'application/json',
  };

  Future<LoginResModel> signin(LoginReqModel reqModel) async {
    try {
      final url = Uri.parse('$baseUrl/signin');
      final response = await http.post(url, headers: jsonHeader, body: json.encode(reqModel.toJson()));
      if (response.statusCode == 200) {
        return LoginResModel.fromJson(json.decode(response.body));
      } else {
        throw 'Invalid credentials';
      }
    } on SocketException catch (e) {
      // handle no internet connection
      throw NoInternetException('No internet connected. Please check your internet again.');
    } catch (e) {
      'sign-in exception::${e.toString()}'.log();
      throw 'Something went wrong::[$e]';
    }
  }
}
