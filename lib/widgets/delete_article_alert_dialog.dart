import 'package:flutter/material.dart';

class DeleteArticleAlertDialog extends StatelessWidget {
  const DeleteArticleAlertDialog({
    super.key,
    this.callback,
  });

  final ValueChanged<String>? callback;

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
          onPressed: () {
            Navigator.of(context).pop('Yes');
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('No');
          },
          child: Text('No'),
        ),
      ],
    );
  }
}
