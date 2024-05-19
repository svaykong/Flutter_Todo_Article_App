import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logger.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // check user login via shared preferences
  Future<void> checkUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    '_isAuthenticated::$_isAuthenticated'.log();

    notifyListeners();
  }

  // update login status
  Future<void> updateLoginStatus(BuildContext context, bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', status);
    _isAuthenticated = status;

    notifyListeners();
  }

  // clear data
  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // remove all data from shared preferences

    // prefs.remove('isAuthenticated'); // remove specific from shared preferences

    _isAuthenticated = false;
    notifyListeners();
  }
}
