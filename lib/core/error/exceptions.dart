class AppException implements Exception {
  final String message;
  final String? details;

  const AppException(this.message, [this.details]);

  @override
  String toString() {
    return 'AppException: $message${details != null ? ' - $details' : ''}';
  }
}

class NetworkException extends AppException {
  const NetworkException(super.message, [super.details]);
}

class ServerException extends AppException {
  const ServerException(super.message, [super.details]);
}

class CacheException extends AppException {
  const CacheException(super.message, [super.details]);
}

class ValidationException extends AppException {
  const ValidationException(super.message, [super.details]);
}
