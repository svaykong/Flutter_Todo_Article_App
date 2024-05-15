import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../utils/logger.dart';
import '../providers/export_provider.dart';
import '../widgets/export_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const routeId = '/profile-page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ArticleProvider _articleProvider;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _articleProvider = context.read<ArticleProvider>();
    _articleProvider.addListener(onArticleChange);
  }

  @override
  void dispose() {
    _articleProvider.removeListener(onArticleChange);
    super.dispose();
  }

  // confirm alert dialog for logout
  Future<void> _showLogoutDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return LogoutAlertDialog();
        });
  }

  void onArticleChange() async {
    '[Profile Page] on article change::'.log();

    if (context.mounted) {
      setState(() {
        _errorMsg = _articleProvider.errorMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User AAA'),
        actions: [
          IconButton(
            onPressed: _errorMsg.isNotEmpty ? null : () async => await _showLogoutDialog(context),
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
