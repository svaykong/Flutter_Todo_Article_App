import 'package:shared_preferences/shared_preferences.dart';

import '../models/article_model.dart';
import '../utils/logger.dart';
import '../data/network/network_api_service.dart';

class ArticleService {
  late final NetworkApiService _apiService;

  ArticleService._() {
    _apiService = NetworkApiService.getInstance;
  }

  static ArticleService get instance => ArticleService._();

  Future<String> get _getToken async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token') ?? '';

    return token.toString();
  }

  Future<Map<String, String>> get _header async {
    final token = await _getToken;
    return {'Authorization': token.toString(), 'Content-Type': 'application/json'};
  }

  Future<List<Article>> getAllArticles() async {
    try {
      // make token expired
      // token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZXhwIjoxNzE1NDI1MTkxfQ.dNrU0KNrLmu6L_0dXtQU80l8cMkI78dSchHaOno29Ls';

      final header = await _header;
      final jsonStr = await _apiService.getRequest(url: '/articles', header: header);
      return ListArticles.fromJson(jsonStr).articles;
    } catch (e) {
      'getAllArticles exception::$e'.log();
      throw e.toString();
    }
  }

  Future<void> createArticle(Map<String, dynamic> postData) async {
    try {
      final header = await _header;
      await _apiService.postRequest(url: '/articles', header: header, postData: postData);
      'create article successfully'.log();
    } catch (e) {
      'create article exception::$e'.log();
      throw e.toString();
    }
  }

  Future<void> updateArticle(int articleId, Map<String, String> postData) async {
    try {
      final header = await _header;
      await _apiService.putRequest(url: '/articles', id: articleId, header: header, postData: postData);
      'update article successfully'.log();
    } catch (e) {
      'update article exception::$e'.log();
      throw e.toString();
    }
  }

  Future<void> deleteArticle(int articleId) async {
    try {
      final header = await _header;
      await _apiService.deleteRequest(url: '/articles', id: articleId, header: header);

      'article delete successfully'.log();
    } catch (e) {
      'deleteArticle exception::$e'.log();
      throw e.toString();
    }
  }
}
