import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;

import 'package:dio/dio.dart';

import '../../constants/constants.dart';
import '../../data/app_exception.dart';
import '../../utils/logger.dart';
import 'base_network_api_service.dart';

const Map<String, String> _defaultHeader = {'Content-Type': 'application/json'};
final _dio = Dio(
  BaseOptions(baseUrl: baseUrl, headers: _defaultHeader),
);

@immutable
class NetworkApiService implements BaseNetworkApiService {
  const NetworkApiService._();

  static NetworkApiService get getInstance => const NetworkApiService._();

  void _log(String msg) {
    'NetworkApiService [$msg]'.log();
  }

  /// [_isInternetAvailable] Checks if the
  /// internet connection is available or not.
  Future<bool> _isInternetAvailable() async {
    try {
      final listInternetAddresses = await InternetAddress.lookup('google.com');
      return listInternetAddresses.isNotEmpty && listInternetAddresses[0].rawAddress.isNotEmpty ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _internetCheck() async {
    final hasInternet = await _isInternetAvailable();
    if (hasInternet == false) {
      throw const NoInternetException('Please check your internet connection again.');
    }
  }

  void _commonErrorsCheck(int? statusCode) {
    if (statusCode == 400) {
      throw const BadRequestException('Bad Request, please check again.');
    } else if (statusCode == 401) {
      throw const UnAuthorizedException('Unauthorized request, please login again.');
    }
    throw const ServerErrorException('Server has error, please wait moment.');
  }

  @override
  Future<Map<String, dynamic>> getRequest({required String url, Map<String, String>? header}) async {
    try {
      await _internetCheck();

      if (header != null) {
        _dio.options.headers = header;
      }
      final response = await _dio.get(url);

      /*
      * For get request the response status code always
      * 200. Otherwise we will return error.
      * */
      if (response.statusCode != 200) {
        _log('response status code::[${response.statusCode}');
        _log('response body::[${response.data}]');

        _commonErrorsCheck(response.statusCode);
      }
      return response.data;
    } on DioException catch (e) {
      _commonErrorsCheck(e.response?.statusCode);

      throw e.message.toString();
    } catch (e) {
      _log('getRequest :: Something went wrong: [$e]');

      throw e.toString();
    } finally {
      _log('getRequest finally');
    }
  }

  @override
  Future<Map<String, dynamic>> postRequest({required String url, required Map<String, dynamic> postData, Map<String, String>? header}) async {
    try {
      await _internetCheck();

      if (header != null) {
        _dio.options.headers = header;
      }
      final response = await _dio.post(url, data: postData);

      /*
      * For post request the response status code always
      * 200 or 201. Otherwise we will return error.
      * */
      if (response.statusCode != 200 && response.statusCode != 201) {
        _log('response status code::[${response.statusCode}');
        _log('response body::[${response.data}]');

        _commonErrorsCheck(response.statusCode);
      }
      return response.data;
    } on DioException catch (e) {
      _log('${e.message}');
      _log('response status code::[${e.response?.statusCode}');
      _log('response status statusMessage::[${e.response?.statusMessage}');

      _commonErrorsCheck(e.response?.statusCode);

      throw e.message.toString();
    } catch (e) {
      _log('postRequest :: Something went wrong: [$e]');
      throw e.toString();
    } finally {
      _log('postRequest finally');
    }
  }

  @override
  Future<Map<String, dynamic>> putRequest({required String url, required int id, required Map<String, dynamic> postData, Map<String, String>? header}) async {
    try {
      await _internetCheck();

      if (header != null) {
        _dio.options.headers = header;
      }
      final response = await _dio.put('$url/$id', data: postData);

      /*
      * For put request the response status code always
      * 200 or 204. Otherwise we will return error.
      * */
      if (response.statusCode != 200 && response.statusCode != 204) {
        _log('response status code::[${response.statusCode}');
        _log('response body::[${response.data}]');

        _commonErrorsCheck(response.statusCode);
      }
      return response.data;
    } on DioException catch (e) {
      _commonErrorsCheck(e.response?.statusCode);

      throw e.message.toString();
    } catch (e) {
      _log('putRequest :: Something went wrong: [$e]');
      throw e.toString();
    } finally {
      _log('putRequest finally');
    }
  }

  @override
  Future<Map<String, dynamic>> deleteRequest({required String url, required int id, Map<String, String>? header}) async {
    try {
      await _internetCheck();

      if (header != null) {
        _dio.options.headers = header;
      }
      final response = await _dio.delete('$url/$id');

      /*
      * For delete request the response status code always
      * 200 or 202. Otherwise we will return error.
      * */
      if (response.statusCode != 200 && response.statusCode != 202) {
        _log('response status code::[${response.statusCode}');
        _log('response body::[${response.data}]');

        _commonErrorsCheck(response.statusCode);
      }
      return response.data;
    } on DioException catch (e) {
      _commonErrorsCheck(e.response?.statusCode);

      throw e.message.toString();
    } catch (e) {
      _log('deleteRequest :: Something went wrong: [$e]');
      throw e.toString();
    } finally {
      _log('deleteRequest finally');
    }
  }
}
