import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/export_provider.dart';

class RemoveAllFavoriteArticleAlertDialog extends StatelessWidget {
  const RemoveAllFavoriteArticleAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Favorite Article'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Are you want to delete all favorite articles?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await context.read<ArticleProvider>().removeAllFavorite();
            if (!context.mounted) return;
            Navigator.of(context).pop();
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
