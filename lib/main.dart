import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'providers/export_provider.dart';
import 'root_app/root_app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider<ArticleProvider>(
          create: (context) => ArticleProvider(),
        ),
      ],
      child: RootApp(),
    ),
  );
}
