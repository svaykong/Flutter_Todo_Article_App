import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'article/update_article_argument.dart';
import '../widgets/export_widget.dart';
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
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();

    _articleProvider = context.read<ArticleProvider>();
    _articleProvider.addListener(onArticleChange);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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

    if (context.mounted) {
      setState(() {
        _showLoading = _articleProvider.isLoading;
        _errorMsg = _articleProvider.errorMsg;
      });
    }

    if (_errorMsg.isNotEmpty) {
      'errorMsg::[$_errorMsg]'.log();

      String displayErrMsg = _errorMsg;

      if (_errorMsg.contains('_message:')) {
        displayErrMsg = _errorMsg.substring(_errorMsg.indexOf('_message:') + 9, _errorMsg.indexOf('}')).trim();
      }

      if (_errorMsg.contains('Token is invalid') || _errorMsg.contains('UnauthorizedException')) {
        if (_errorMsg.contains('Token is invalid')) {
          displayErrMsg = 'Your session is end. Please login again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(displayErrMsg),
          ),
        );

        // clear data
        await context.read<AuthenticationProvider>().clearData();
      } else if (_errorMsg.contains('Connection refused')) {
        // handle Connection refused
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server has problem. Please try again later'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(displayErrMsg),
          ),
        );
      }
    } else {
      setState(() {
        _article = _articleProvider.listArticles;
      });
    }
  }

  Future<void> onRefresh({bool onRefreshCall = false, BuildContext? context}) async {
    'onRefresh call...'.log();

    // close for awhile
    // if (_errorMsg.isNotEmpty) {
    //   return;
    // }

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

  Future<void> onEdit(Article currentArticle, BuildContext context) async {
    Navigator.of(context).pushNamed(UpdateArticlePage.routeId, arguments: UpdateArticleArgument(article: currentArticle)).then((value) async {
      if (value == true) {
        await onRefresh(context: context);
      }
    });
  }

  Future<void> onDelete(int articleId, BuildContext context) async {
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    // show alert dialog delete article
    final String? result = await showDialog(
        context: context,
        builder: (context) {
          return DeleteArticleAlertDialog();
        });

    'result:: $result'.log();
    if (result == 'Yes') {
      await _articleProvider.onDeleteArticle(articleId);
      messenger.showSnackBar(SnackBar(content: Text('delete article successfully...')));
      await onRefresh();
    }
  }

  Future<void> onToggleFavorite(Article article) async {
    await _articleProvider.onToggleFavoriteArticle(article);
    _articleProvider.filterFavorite();
  }

  Widget get _handleServerIssue {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'We\'re sorry our app has problem,\nplease try again later.',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: () async {
              await onRefresh(context: context);
            },
            child: Text(
              'Refresh',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article App'),
        actions: [
          IconButton(
            onPressed: _errorMsg.isNotEmpty
                ? null
                : () {
                    Navigator.of(context).pushNamed(FavoritePage.routeId);
                  },
            icon: Icon(
              Icons.view_list_rounded,
              color: Colors.deepPurple,
            ),
          ),
          IconButton(
            onPressed: _errorMsg.isNotEmpty
                ? null
                : () async {
                    await onRefresh(context: context);
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
            : (_errorMsg.isNotEmpty && _errorMsg.contains('Connection refused'))
                ? _handleServerIssue
                : RefreshIndicator(
                    onRefresh: () async => onRefresh(onRefreshCall: true, context: context),
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
                                        _errorMsg.isNotEmpty ? null : Navigator.of(context).pushNamed(ArticleListPage.routeId);
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
                                          _errorMsg.isNotEmpty ? null : Navigator.of(context).pushNamed(DetailArticlePage.routeId, arguments: _article[index].id);
                                        },
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(_article[index].title),
                                        subtitle: Text(_article[index].description),
                                        trailing: Row(
                                          // required to add mainAxisSize property to min (default max)
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: _errorMsg.isNotEmpty ? null : () async => await onToggleFavorite(_article[index]),
                                              icon: Icon(
                                                articleIndex > -1 ? Icons.favorite_outlined : Icons.favorite_outline,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: _errorMsg.isNotEmpty ? null : () async => await onEdit(_article[index], context),
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: _errorMsg.isNotEmpty ? null : () async => await onDelete(_article[index].id, context),
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
        onPressed: _errorMsg.isNotEmpty
            ? null
            : () => Navigator.of(context).pushNamed(AddArticlePage.routeId).then((value) async {
                  if (value == true) {
                    await onRefresh(context: context);
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
