import 'dart:convert' as json;

import 'package:http/http.dart' as http;

import '../../utils/logger.dart';
import 'base_network_api_service.dart';

class NetworkApiService implements BaseNetworkApiService {
  NetworkApiService._();

  static NetworkApiService get getInstance => NetworkApiService._();

  static const Map<String, String> defaultHeader = {'Content-Type': 'application/json'};

  @override
  Future<Map<String, dynamic>> getRequest({required String url, Map<String, String>? header = defaultHeader}) async {
    try {
      final response = await http.get(Uri.parse(url), headers: header);
      'response status code::[${response.statusCode}]'.log();
      'response body::[${response.body}]'.log();

      /*
      * For get request the response status code always
      * 200. Otherwise we will return error.
      * */
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
  Future<Map<String, dynamic>> postRequest({required String url, required String postData, Map<String, String>? header = defaultHeader}) async {
    try {
      final response = await http.post(Uri.parse(url), body: postData, headers: header);
      'response status code::[${response.statusCode}]'.log();
      'response body::[${response.body}]'.log();

      /*
      * For post request the response status code always
      * 200 or 201. Otherwise we will return error.
      * */
      if (response.statusCode != 200 && response.statusCode != 201) {
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
  Future<Map<String, dynamic>> putRequest({required String url, required int id, required String postData, Map<String, String>? header = defaultHeader}) async {
    try {
      final response = await http.put(Uri.parse('$url/$id'), body: postData, headers: header);
      'response status code::[${response.statusCode}]'.log();
      'response body::[${response.body}]'.log();

      /*
      * For put request the response status code always
      * 200 or 204. Otherwise we will return error.
      * */
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw 'Unknown error: ${response.body}';
      }
      return json.jsonDecode(response.body);
    } catch (e) {
      throw 'Something went wrong: $e';
    } finally {
      'NetworkApiService putRequest finally'.log();
    }
  }

  @override
  Future<Map<String, dynamic>> deleteRequest({required String url, required int id, Map<String, String>? header = defaultHeader}) async {
    try {
      final response = await http.delete(Uri.parse('$url/$id'), headers: header);
      'response status code::[${response.statusCode}]'.log();
      'response body::[${response.body}]'.log();

      /*
      * For delete request the response status code always
      * 200 or 202. Otherwise we will return error.
      * */
      if (response.statusCode != 200 && response.statusCode != 202) {
        throw 'Unknown error: ${response.body}';
      }
      return json.jsonDecode(response.body);
    } catch (e) {
      throw 'Something went wrong: $e';
    } finally {
      'NetworkApiService deleteRequest finally'.log();
    }
  }
}
