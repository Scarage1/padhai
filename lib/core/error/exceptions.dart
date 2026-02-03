// lib/core/error/exceptions.dart
// DO NOT MODIFY - Locked by DOC-002

class ServerException implements Exception {
  final String message;
  final String? code;

  ServerException(this.message, {this.code});

  @override
  String toString() => 'ServerException: $message ${code != null ? '($code)' : ''}';
}

class CacheException implements Exception {
  final String message;
  final String? code;

  CacheException(this.message, {this.code});

  @override
  String toString() => 'CacheException: $message ${code != null ? '($code)' : ''}';
}

class NetworkException implements Exception {
  final String message;
  final String? code;

  NetworkException(this.message, {this.code});

  @override
  String toString() => 'NetworkException: $message ${code != null ? '($code)' : ''}';
}

class DatabaseException implements Exception {
  final String message;
  final String? code;

  DatabaseException(this.message, {this.code});

  @override
  String toString() => 'DatabaseException: $message ${code != null ? '($code)' : ''}';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;

  ValidationException(this.message, {this.errors});

  @override
  String toString() => 'ValidationException: $message ${errors != null ? errors : ''}';
}
