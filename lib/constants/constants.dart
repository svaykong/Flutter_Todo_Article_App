import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

/*
* Nox: http://172.17.100.2:8000/api/v1
* Android: http://10.0.2.2:8000/api/v1
* */
String baseUrl = defaultTargetPlatform == TargetPlatform.android ? 'http://10.0.3.16:8000/api/v1' : 'http://localhost:8000/api/v1';
