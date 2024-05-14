import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/remove_all_favorite_article_alert_dialog.dart';
import '../models/article_model.dart';
import '../providers/export_provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  static const routeId = '/favorite-page';

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late ArticleProvider _articleProvider;
  List<Article> _favorites = [];

  Future<void> onToggleFavorite(Article article) async {
    await _articleProvider.onToggleFavoriteArticle(article);
    _articleProvider.filterFavorite();
  }

  // confirm alert dialog for remove all favorite articles
  Future<void> _showRemoveAllFavoriteAlertDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return RemoveAllFavoriteArticleAlertDialog();
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _articleProvider = context.read<ArticleProvider>();
      _articleProvider.addListener(onArticleChange);
      setState(() {
        _favorites = _articleProvider.filters;
      });
    });
  }

  @override
  void dispose() {
    _articleProvider.removeListener(onArticleChange);
    super.dispose();
  }

  void onArticleChange() {
    setState(() {
      _favorites = _articleProvider.filters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorite'),
        actions: [
          IconButton(
            onPressed: () async {
              await _showRemoveAllFavoriteAlertDialog(context);
            },
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _favorites.isEmpty
            ? Center(
                child: const Text('No favorite article.'),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(8.0),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _favorites.length,
                  itemBuilder: (BuildContext context, int index) {
                    int articleIndex = _articleProvider.listFavoriteArticleIds.indexOf(_favorites[index].id.toString());

                    return ListTile(
                      title: Text(_favorites[index].title),
                      subtitle: Text(_favorites[index].description),
                      trailing: IconButton(
                        onPressed: () => onToggleFavorite(_favorites[index]),
                        icon: Icon(
                          articleIndex > -1 ? Icons.favorite_outlined : Icons.favorite_outline,
                          color: Colors.deepPurple,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(),
                ),
              ),
      ),
    );
  }
}
