import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/export_provider.dart';

class DeleteArticleAlertDialog extends StatelessWidget {
  const DeleteArticleAlertDialog({
    super.key,
    required this.articleId,
    required this.callback,
  });

  final int articleId;
  final ValueChanged<String?> callback;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Article'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Are you want to Delete?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            try {
              await context.read<ArticleProvider>().onDeleteArticle(articleId);
              if (!context.mounted) return;
              Navigator.of(context).pop();
              callback(null);
            } catch (e) {
              callback(e.toString());
            }
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),
      ],
    );
  }
}
