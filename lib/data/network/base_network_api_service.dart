import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class BaseNetworkApiService {
  Future<Map<String, dynamic>> getRequest({required String url});

  Future<Map<String, dynamic>> postRequest({required String url, required Map<String, dynamic> postData});

  Future<Map<String, dynamic>> putRequest({required String url, required int id, required Map<String, dynamic> postData});

  Future<Map<String, dynamic>> deleteRequest({required String url, required int id});
}
