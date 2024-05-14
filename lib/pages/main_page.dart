import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../utils/logger.dart';
import 'export_page.dart';
import '../providers/export_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const routeId = '/main-page';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final AuthenticationProvider _authenticationProvider;

  int _currentIndex = 0;
  final _page = [
    const HomePage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _authenticationProvider = context.read<AuthenticationProvider>();
    _authenticationProvider.addListener(onAuthChange);
  }

  @override
  void dispose() {
    _authenticationProvider.removeListener(onAuthChange);
    super.dispose();
  }

  // on auth change
  void onAuthChange() {
    '[Main Page] onAuthChange...'.log();
    if (!_authenticationProvider.isAuthenticated) {
      Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routeId, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
