import 'package:flutter/material.dart';

import '../pages/export_page.dart';

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
