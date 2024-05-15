import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class BaseNetworkApiService {
  Future<Map<String, dynamic>> getRequest({required String url, Map<String, String>? header});

  Future<Map<String, dynamic>> postRequest({required String url, required String postData, Map<String, String>? header});

  Future<Map<String, dynamic>> deleteRequest({required String url, required int id, Map<String, String>? header});

  Future<Map<String, dynamic>> putRequest({required String url, required int id, required String postData, Map<String, String>? header});
}
