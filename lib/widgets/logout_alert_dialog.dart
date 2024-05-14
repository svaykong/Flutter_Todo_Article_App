import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/export_provider.dart';

class LogoutAlertDialog extends StatelessWidget {
  const LogoutAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Are you want to logout?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await context.read<AuthenticationProvider>().clearData();
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
