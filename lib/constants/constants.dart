import 'dart:io' show Platform;

String baseUrl = Platform.isIOS ? 'http://localhost:8000/api/v1' : 'http://172.17.100.2:8000/api/v1';
