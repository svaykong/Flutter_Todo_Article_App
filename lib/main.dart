import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'pages/export_page.dart';
import 'providers/export_provider.dart';

void main() {
  runApp(MultiProvider(
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
  ));
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashPage.routeId,
      routes: <String, WidgetBuilder>{
        SplashPage.routeId: (_) => SplashPage(),
        LoginPage.routeId: (_) => LoginPage(),
        MainPage.routeId: (_) => MainPage(),
        HomePage.routeId: (_) => HomePage(),
        ProfilePage.routeId: (_) => ProfilePage(),
        FavoritePage.routeId: (_) => FavoritePage(),
        ArticleListPage.routeId: (_) => ArticleListPage(),
        AddArticlePage.routeId: (_) => AddArticlePage(),
        UpdateArticlePage.routeId: (_) => UpdateArticlePage(),
        DetailArticlePage.routeId: (_) => DetailArticlePage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => NotFoundPage());
      },
    );
  }
}
