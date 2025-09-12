class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class RemoteStorageException implements Exception {
  const RemoteStorageException(this.message);
  final String message;

  @override
  String toString() => 'RemoteStorageException: $message';
}

class AuthenticationException implements Exception {
  const AuthenticationException(this.message);
  final String message;

  @override
  String toString() => 'AuthenticationException: $message';
}

class PermissionException implements Exception {
  const PermissionException(this.message);
  final String message;

  @override
  String toString() => 'PermissionException: $message';
}

class NotFoundException implements Exception {
  const NotFoundException(this.message);
  final String message;

  @override
  String toString() => 'NotFoundException: $message';
}