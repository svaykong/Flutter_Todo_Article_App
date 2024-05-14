import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/article_model.dart';
import '../utils/logger.dart';

class ArticleService {
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get('token') ?? '';

    return token.toString();
  }

  Future<List<Article>> getAllArticles() async {
    var token = await getToken();

    var header = {'Authorization': token.toString()};

    try {
      final response = await http.get(Uri.parse('$baseUrl/articles'), headers: header);
      if (response.statusCode == 200) {
        final jsonStr = json.decode(response.body);

        return ListArticles.fromJson(jsonStr).articles;
      } else {
        'status code:: ${response.statusCode}'.log();
        'response:: ${response.body}'.log();
        throw 'Something went wrong: ${response.body}';
      }
    } catch (e) {
      'getAllArticles exception::$e'.log();
      throw 'Failed to fetch all articles. $e';
    }
  }

  Future<void> createArticle(Map<String, String> postData) async {
    try {
      var token = await getToken();
      var header = {'Authorization': token.toString(), 'Content-Type': 'application/json'};

      final response = await http.post(Uri.parse('$baseUrl/articles'), headers: header, body: json.encode(postData));
      'response status code:: [${response.statusCode}]'.log();
      'response body:: [${response.body}]'.log();

      if (response.statusCode == 200 || response.statusCode == 201) {
        'create article successfully'.log();
        return;
      } else {
        throw 'Something went wrong: ${response.body}';
      }
    } catch (e) {
      'create article exception::$e'.log();
      throw 'Failed to create article. $e';
    }
  }

  Future<void> updateArticle(int articleId, Map<String, String> postData) async {
    try {
      var token = await getToken();

      // making token expired
      // token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZXhwIjoxNzE1NDEwNzUwfQ.l15MFMqxzdk_RRDDSBnn1JL4adTTfXqGCoZTeRlpJrs';

      var header = {'Authorization': token.toString(), 'Content-Type': 'application/json'};

      final response = await http.put(Uri.parse('$baseUrl/articles/$articleId'), headers: header, body: json.encode(postData));
      'response status code:: [${response.statusCode}]'.log();
      'response body:: [${response.body}]'.log();

      if (response.statusCode == 200 || response.statusCode == 201) {
        'update article successfully'.log();
        return;
      } else {
        throw 'Something went wrong: ${response.body}';
      }
    } catch (e) {
      'update article exception::$e'.log();
      throw 'Failed to update article. $e';
    }
  }

  Future<void> deleteArticle(int articleId) async {
    var token = await getToken();
    var header = {'Authorization': token.toString()};

    try {
      final response = await http.delete(Uri.parse('$baseUrl/articles/$articleId'), headers: header);
      if (response.statusCode == 200 || response.statusCode == 202) {
        'article delete successfully'.log();
        return;
      } else {
        'status code:: ${response.statusCode}'.log();
        'response:: ${response.body}'.log();
        throw 'Something went wrong: ${response.body}';
      }
    } catch (e) {
      'deleteArticle exception::$e'.log();
      throw 'Failed to delete article. $e';
    }
  }
}
