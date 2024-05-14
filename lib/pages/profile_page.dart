import 'package:flutter/material.dart';

import '../widgets/export_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeId = '/profile-page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // confirm alert dialog for logout
  Future<void> _showLogoutDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return LogoutAlertDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User AAA'),
        actions: [
          IconButton(
            onPressed: () async => await _showLogoutDialog(context),
            icon: Icon(Icons.logout, color: Colors.deepPurple),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
