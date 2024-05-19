import 'package:flutter/foundation.dart' show immutable;

import '../data/network/network_api_service.dart';
import '../utils/logger.dart';
import '../models/login_req_model.dart';
import '../models/login_res_model.dart';

final NetworkApiService _networkApiService = NetworkApiService.getInstance;

@immutable
class AuthenticationService {
  const AuthenticationService._();

  static AuthenticationService get instance => const AuthenticationService._();

  Future<LoginResModel> signin(LoginReqModel reqModel) async {
    try {
      final resultJson = await _networkApiService.postRequest(url: '/signin', postData: reqModel.toJson());

      return LoginResModel.fromJson(resultJson);
    } catch (e) {
      'AuthenticationService signin exception::${e.toString()}'.log();
      throw e.toString();
    }
  }
}
