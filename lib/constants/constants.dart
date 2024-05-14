import 'dart:io' show Platform;

String baseUrl = Platform.isIOS ? 'http://localhost:8000/api/v1' : 'http://192.168.0.169:8000/api/v1';
