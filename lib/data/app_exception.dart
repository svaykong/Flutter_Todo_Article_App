import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppException implements Exception {
  const AppException(this._prefix, this._message);

  final String? _prefix;
  final String? _message;

  @override
  String toString() {
    return 'AppException{_prefix: $_prefix, _message: $_message}';
  }
}

class NoInternetException extends AppException {
  const NoInternetException(String? message) : super('NoInternetException', message);
}

class BadRequestException extends AppException {
  const BadRequestException(String? message) : super('BadRequestException', message);
}

class UnAuthorizedException extends AppException {
  const UnAuthorizedException(String? message) : super('UnauthorizedException', message);
}

class ServerErrorException extends AppException {
  const ServerErrorException(String? message) : super('ServerErrorException', message);
}
