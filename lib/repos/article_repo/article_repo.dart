import '../../models/article_model.dart';
import 'base_article_repo.dart';

class ArticleRepo implements BaseArticleRepo {
  ArticleRepo._();

  // static late final NetworkApiService _apiService;

  static ArticleRepo getInstance() {
    return ArticleRepo._();
  }

  @override
  Future<void> createArticle(Map<String, String> postData) {
    // TODO: implement createArticle
    throw UnimplementedError();
  }

  @override
  Future<void> deleteArticle(int articleId) {
    // TODO: implement deleteArticle
    throw UnimplementedError();
  }

  @override
  Future<List<Article>> getAllArticles() {
    // TODO: implement getAllArticles
    throw UnimplementedError();
  }

  @override
  Future<void> updateArticle(int articleId, Map<String, String> postData) {
    // TODO: implement updateArticle
    throw UnimplementedError();
  }
}
