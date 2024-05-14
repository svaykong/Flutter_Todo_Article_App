import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppException implements Exception {
  const AppException(this.message) : super();

  final String message;

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException(super.message);
}
