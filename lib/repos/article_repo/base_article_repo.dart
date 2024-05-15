import 'package:flutter/foundation.dart' show immutable;

import '../../models/article_model.dart';

@immutable
abstract class BaseArticleRepo {
  Future<List<Article>> getAllArticles();

  Future<void> createArticle(Map<String, String> postData);

  Future<void> updateArticle(int articleId, Map<String, String> postData);

  Future<void> deleteArticle(int articleId);
}
