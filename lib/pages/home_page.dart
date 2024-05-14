import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'article/update_article_argument.dart';
import '../widgets/delete_article_alert_dialog.dart';
import '../providers/export_provider.dart';
import 'export_page.dart';
import '../utils/logger.dart';
import '../models/article_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeId = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ArticleProvider _articleProvider;
  List<Article> _article = [];

  bool _showLoading = false;

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
    '[Home Page] on article change::'.log();

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
        _article = _articleProvider.listArticles;
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
        title: Text('Article App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(FavoritePage.routeId);
            },
            icon: Icon(
              Icons.view_list_rounded,
              color: Colors.deepPurple,
            ),
          ),
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
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  height: MediaQuery.of(context).size.height,
                  child: _article.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No article yet.',
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(AddArticlePage.routeId);
                                  },
                                  child: Text(
                                    'Create',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('All Articles'),

                                // view all
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(ArticleListPage.routeId);
                                  },
                                  child: Text('View All'),
                                )
                              ],
                            ),
                            Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: _article.length,
                                itemBuilder: (BuildContext context, int index) {
                                  int articleIndex = _articleProvider.listFavoriteArticleIds.indexOf(_article[index].id.toString());

                                  return ListTile(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(DetailArticlePage.routeId, arguments: _article[index].id);
                                    },
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(_article[index].title),
                                    subtitle: Text(_article[index].description),
                                    trailing: Row(
                                      // required to add mainAxisSize property to min (default max)
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async => await onToggleFavorite(_article[index]),
                                          icon: Icon(
                                            articleIndex > -1 ? Icons.favorite_outlined : Icons.favorite_outline,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async => await onEdit(_article[index]),
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async => await onDelete(_article[index].id),
                                          icon: Icon(
                                            Icons.delete_rounded,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => Divider(),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.of(context).pushNamed(AddArticlePage.routeId).then((value) async {
          if (value == true) {
            await onRefresh();
          }
        }),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
