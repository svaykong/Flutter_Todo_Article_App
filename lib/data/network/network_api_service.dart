import 'dart:convert' as json;

import 'package:http/http.dart' as http;

import '../../utils/logger.dart';
import 'base_network_api_service.dart';

class NetworkApiService implements BaseNetworkApiService {
  NetworkApiService._();

  static NetworkApiService get getInstance => NetworkApiService._();

  @override
  Future<Map<String, dynamic>> deleteRequest({required String url, required int id, Map<String, String>? header}) async {
    try {
      final response = await http.delete(Uri.parse('$url/$id'), headers: header);
      if (response.statusCode != 200) {
        throw 'Unknown error: ${response.body}';
      }
      return json.jsonDecode(response.body);
    } catch (e) {
      throw 'Something went wrong: $e';
    } finally {
      'NetworkApiService deleteRequest finally'.log();
    }
  }

  @override
  Future<Map<String, dynamic>> getRequest({required String url, Map<String, String>? header}) async {
    try {
      final response = await http.get(Uri.parse(url), headers: header);
      if (response.statusCode != 200) {
        throw 'Unknown error: ${response.body}';
      }
      return json.jsonDecode(response.body);
    } catch (e) {
      throw 'Something went wrong: $e';
    } finally {
      'NetworkApiService getRequest finally'.log();
    }
  }

  @override
  Future<Map<String, dynamic>> postRequest({required String url, required String postData, Map<String, String>? header}) async {
    try {
      final response = await http.post(Uri.parse(url), body: postData, headers: header);
      if (response.statusCode != 200) {
        throw 'Unknown error: ${response.body}';
      }
      return json.jsonDecode(response.body);
    } catch (e) {
      throw 'Something went wrong: $e';
    } finally {
      'NetworkApiService postRequest finally'.log();
    }
  }

  @override
  Future<Map<String, dynamic>> putRequest({required String url, required int id, required String postData, Map<String, String>? header}) async {
    try {
      final response = await http.put(Uri.parse('$url/$id'), body: postData, headers: header);
      if (response.statusCode != 200) {
        throw 'Unknown error: ${response.body}';
      }
      return json.jsonDecode(response.body);
    } catch (e) {
      throw 'Something went wrong: $e';
    } finally {
      'NetworkApiService putRequest finally'.log();
    }
  }
}
