// You can pass any object to the arguments parameter.
// In this example, create a class that contains both
// a customizable title and message.

import '../../models/article_model.dart';

class ArticleListArgument {
  final List<Article> articles;

  const ArticleListArgument({required this.articles});
}
