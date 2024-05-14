import 'package:flutter/material.dart';

import 'export_page.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  static const routeId = '/not-found-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Not Found.'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // go home
                  Navigator.of(context).pushReplacementNamed(HomePage.routeId);
                },
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
