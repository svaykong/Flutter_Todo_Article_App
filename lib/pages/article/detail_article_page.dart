import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../utils/logger.dart';
import '../../models/article_model.dart';
import '../../providers/article_provider.dart';

class DetailArticlePage extends StatelessWidget {
  const DetailArticlePage({super.key});

  static const routeId = 'detail-article-page';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as int;
    final articles = context.read<ArticleProvider>().listArticles;
    Article? articleResult;
    try {
      articleResult = articles.firstWhere((article) => article.id == args);
      'articleResult::$articleResult'.log();
    } catch (e) {
      'exception::$e'.log();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Article ID: ${articleResult?.id ?? 'Not found'}'),
      ),
      body: SafeArea(
        child: articleResult == null
            ? Container(
                alignment: Alignment.center,
                child: Text('No article found.'),
              )
            : Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      articleResult.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      articleResult.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
  }
}
