class ServerException implements Exception {
  const ServerException({required this.message});

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  const CacheException({required this.message});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  const ValidationException({required this.message, this.field});

  final String message;
  final String? field;

  @override
  String toString() {
    if (field != null) {
      return 'ValidationException[$field]: $message';
    }
    return 'ValidationException: $message';
  }
}
