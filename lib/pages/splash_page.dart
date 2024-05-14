import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'export_page.dart';
import '../providers/export_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routeId = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthenticationProvider authenticationProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      authenticationProvider = context.read<AuthenticationProvider>();
      authenticationProvider.addListener(onAuthChange);
      authenticationProvider.checkUserLogin();
    });
  }

  // on auth change
  void onAuthChange() {
    if (authenticationProvider.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(MainPage.routeId);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginPage.routeId);
    }
  }

  @override
  void dispose() {
    authenticationProvider.removeListener(onAuthChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
