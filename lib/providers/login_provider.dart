import 'package:flutter/material.dart' show ChangeNotifier;

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logger.dart';
import '../models/login_req_model.dart';
import '../models/login_res_model.dart';
import '../services/export_service.dart';

class LoginProvider extends ChangeNotifier {
  final authenticationService = AuthenticationService.instance;

  bool _isLoading = false;
  String _errorMsg = '';
  LoginResModel? _loginResModel;

  bool get isLoading => _isLoading;

  String get errorMsg => _errorMsg;

  LoginResModel? get loginResModel => _loginResModel;

  Future<void> onLogin({required String email, required String password}) async {
    try {
      _loginResModel = null;
      _errorMsg = '';
      _isLoading = true;
      notifyListeners();

      final loginReqModel = LoginReqModel(email: email, password: password);

      await Future.delayed(Duration(milliseconds: 1000), () {});
      _loginResModel = await authenticationService.signin(loginReqModel);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _loginResModel?.token ?? '');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      'LoginProvider onLogin exception::[$e]'.log();

      _isLoading = false;
      _errorMsg = e.toString();

      notifyListeners();
    }
  }
}
