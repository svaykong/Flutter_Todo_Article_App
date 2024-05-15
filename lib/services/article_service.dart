import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/article_model.dart';
import '../utils/logger.dart';
import '../data/network/network_api_service.dart';

class ArticleService {
  final NetworkApiService _apiService = NetworkApiService.getInstance;

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token') ?? '';

    return token.toString();
  }

  Future<List<Article>> getAllArticles() async {
    var token = await getToken();

    var header = {'Authorization': token.toString()};

    try {
      final jsonStr = await _apiService.getRequest(url: '$baseUrl/articles', header: header);
      return ListArticles.fromJson(jsonStr).articles;
    } catch (e) {
      'getAllArticles exception::$e'.log();
      throw 'Failed to fetch all articles. $e';
    }
  }

  Future<void> createArticle(Map<String, dynamic> postData) async {
    try {
      var token = await getToken();
      var header = {'Authorization': token.toString(), 'Content-Type': 'application/json'};

      await _apiService.postRequest(url: '$baseUrl/articles', header: header, postData: json.encode(postData));
      'create article successfully'.log();
    } catch (e) {
      'create article exception::$e'.log();
      throw 'Failed to create article. $e';
    }
  }

  Future<void> updateArticle(int articleId, Map<String, String> postData) async {
    try {
      var token = await getToken();

      var header = {'Authorization': token.toString(), 'Content-Type': 'application/json'};

      await _apiService.putRequest(url: '$baseUrl/articles', id: articleId, header: header, postData: json.encode(postData));
      'update article successfully'.log();
    } catch (e) {
      'update article exception::$e'.log();
      throw 'Failed to update article. $e';
    }
  }

  Future<void> deleteArticle(int articleId) async {
    var token = await getToken();
    var header = {'Authorization': token.toString()};

    try {
      await _apiService.deleteRequest(url: '$baseUrl/articles', id: articleId, header: header);

      'article delete successfully'.log();
    } catch (e) {
      'deleteArticle exception::$e'.log();
      throw 'Failed to delete article. $e';
    }
  }
}
