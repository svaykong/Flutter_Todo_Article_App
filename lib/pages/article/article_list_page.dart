import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'update_article_argument.dart';
import '../../widgets/export_widget.dart';
import '../../providers/export_provider.dart';
import '../export_page.dart';
import '../../models/article_model.dart';
import '../../utils/logger.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  static const routeId = '/article-list-page';

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  late final ArticleProvider _articleProvider;
  bool _showLoading = false;
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _articleProvider = context.read<ArticleProvider>();
      _articleProvider.addListener(onArticleChange);
      _articleProvider.onGetAllArticles();

      // getting list favorite articles
      await _articleProvider.readListFavoriteArticleIds();
    });
  }

  @override
  void dispose() {
    _articleProvider.removeListener(onArticleChange);
    super.dispose();
  }

  void onArticleChange() async {
    '[Article List Page] on article change::'.log();

    setState(() {
      _showLoading = _articleProvider.isLoading;
    });

    if (_articleProvider.errorMsg.isNotEmpty) {
      if (_articleProvider.errorMsg.contains('Token is invalid')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your session is end. Please login again.'),
          ),
        );

        // clear data
        await context.read<AuthenticationProvider>().clearData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. ${_articleProvider.errorMsg}'),
          ),
        );
      }
    } else {
      setState(() {
        _articles = _articleProvider.listArticles;
      });
    }
  }

  Future<void> onRefresh({bool onRefreshCall = false}) async {
    'onRefresh call...'.log();

    if (_articleProvider.errorMsg.isNotEmpty) {
      return;
    }

    if (onRefreshCall) {
      await _articleProvider.onGetAllArticles();
      await Future.delayed(Duration(milliseconds: 1000), () {});
    } else {
      setState(() {
        _showLoading = true;
      });

      await _articleProvider.onGetAllArticles();

      await Future.delayed(Duration(milliseconds: 1000), () {});

      setState(() {
        _showLoading = false;
      });
    }
  }

  Future<void> onEdit(Article currentArticle) async {
    Navigator.of(context).pushNamed(UpdateArticlePage.routeId, arguments: UpdateArticleArgument(article: currentArticle)).then((value) async {
      if (value == true) {
        await onRefresh();
      }
    });
  }

  Future<void> onDelete(int articleId) async {
    // show alert dialog delete article
    await showDialog(
        context: context,
        builder: (context) {
          return DeleteArticleAlertDialog(
              articleId: articleId,
              callback: (value) async {
                if (value != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('There was an error:: [$value]')));
                } else {
                  // call refresh function again
                  await onRefresh();
                }
              });
        });
  }

  Future<void> onToggleFavorite(Article article) async {
    await _articleProvider.onToggleFavoriteArticle(article);
    _articleProvider.filterFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Articles'),
        actions: [
          IconButton(
            onPressed: () async {
              await onRefresh();
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _showLoading
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async => onRefresh(onRefreshCall: true),
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                  itemCount: _articles.length,
                  itemBuilder: (BuildContext context, int index) {
                    int articleIndex = _articleProvider.listFavoriteArticleIds.indexOf(_articles[index].id.toString());
                    var article = _articles[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(DetailArticlePage.routeId, arguments: _articles[index].id);
                      },
                      title: Text(article.title),
                      subtitle: Text(article.description),
                      trailing: Row(
                        // required to add mainAxisSize property to min (default max)
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => onToggleFavorite(article),
                            icon: Icon(
                              articleIndex > -1 ? Icons.favorite_outlined : Icons.favorite_outline,
                              color: Colors.deepPurple,
                            ),
                          ),
                          IconButton(
                            onPressed: () async => await onEdit(article),
                            icon: Icon(
                              Icons.edit,
                              color: Colors.deepPurple,
                            ),
                          ),
                          IconButton(
                            onPressed: () async => await onDelete(article.id),
                            icon: Icon(
                              Icons.delete_rounded,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
