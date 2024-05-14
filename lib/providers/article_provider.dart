import 'package:flutter/material.dart' show ChangeNotifier;

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/logger.dart';
import '../services/export_service.dart';
import '../models/article_model.dart';

class ArticleProvider extends ChangeNotifier {
  final articleService = ArticleService();

  bool _isLoading = false;
  String _errorMsg = '';
  List<Article> _listArticles = [];
  List<String> _listFavoriteArticleIds = [];
  List<Article> _filters = [];

  bool get isLoading => _isLoading;

  String get errorMsg => _errorMsg;

  List<Article> get listArticles => _listArticles;

  List<String> get listFavoriteArticleIds => _listFavoriteArticleIds;

  List<Article> get filters => _filters;

  Future<void> onGetAllArticles() async {
    try {
      // always initialize here...
      _listFavoriteArticleIds = [];
      _errorMsg = '';
      _isLoading = true;
      notifyListeners();

      await Future.delayed(Duration(milliseconds: 1000), () {});
      _listArticles = await articleService.getAllArticles();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMsg = e.toString();
      notifyListeners();
    }
  }

  // Toggle Favorite Article
  Future<void> onToggleFavoriteArticle(Article selectArticle) async {
    'selected Article:: [$selectArticle]'.log();

    int index = _listFavoriteArticleIds.indexOf(selectArticle.id.toString());
    // if not found add to list
    if (index == -1) {
      _listFavoriteArticleIds.add(selectArticle.id.toString());
    } else {
      // if found we remove from the list
      _listFavoriteArticleIds.removeAt(index);
    }

    // update everytime list favorite change...
    if (_listFavoriteArticleIds.isEmpty) {
      await removeAllFavorite();
    } else {
      await _saveListFavoriteArticleIds();
    }

    notifyListeners();
  }

  // Remove all favorite article
  Future<void> removeAllFavorite() async {
    _listFavoriteArticleIds.clear();
    _filters.clear();
    await _removeListFavoriteArticleIds();

    notifyListeners();
  }

  // Delete article
  Future<void> onDeleteArticle(int articleId) async {
    try {
      _errorMsg = '';
      _isLoading = true;
      notifyListeners();

      await Future.delayed(Duration(milliseconds: 1000), () {});
      await articleService.deleteArticle(articleId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMsg = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // create article
  Future<void> onCreateArticle(Map<String, String> postData) async {
    try {
      _errorMsg = '';
      _isLoading = true;
      notifyListeners();

      await Future.delayed(Duration(milliseconds: 1000), () {});
      await articleService.createArticle(postData);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMsg = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // update article
  Future<void> onUpdateArticle(int articleId, Map<String, String> postData) async {
    try {
      _errorMsg = '';
      _isLoading = true;
      notifyListeners();

      await Future.delayed(Duration(milliseconds: 1000), () {});
      await articleService.updateArticle(articleId, postData);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMsg = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // filter favorite article
  void filterFavorite() {
    _filters = [];

    for (var i = 0; i < _listFavoriteArticleIds.length; i++) {
      for (var j = 0; j < _listArticles.length; j++) {
        if (_listArticles[j].id == _listFavoriteArticleIds[i]) {
          _filters = [
            ..._filters,
            _listArticles[j],
          ];
        }
      }
    }

    notifyListeners();
  }

  /*
  * data persistence
  * 1. save to local
  * 2. remove from local
  * 3. read from local
  * */
  Future<void> _saveListFavoriteArticleIds() async {
    try {
      if (_listFavoriteArticleIds.isEmpty) {
        'no favorites article yet...'.log();
        return;
      }

      var prefs = await SharedPreferences.getInstance();
      prefs.setStringList('listFavorites', _listFavoriteArticleIds);

      'save favorites list successfully...'.log();

      notifyListeners();
    } catch (e) {
      throw '[save list favorite articleIds] Something went wrong: $e';
    }
  }

  Future<void> _removeListFavoriteArticleIds() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      prefs.remove('listFavorites');

      'remove favorites list successfully...'.log();

      notifyListeners();
    } catch (e) {
      throw '[remove list favorite articleIds] Something went wrong: $e';
    }
  }

  Future<void> readListFavoriteArticleIds() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var listFavorites = prefs.getStringList('listFavorites');
      _listFavoriteArticleIds = listFavorites ?? [];

      'read favorites list successfully...'.log();
      'listFavoriteArticleIds::[$listFavorites]'.log();

      notifyListeners();
    } catch (e) {
      throw '[read list favorite articleIds] Something went wrong: $e';
    }
  }
}
