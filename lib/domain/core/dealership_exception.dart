// coverage:ignore-file
sealed class DealershipException implements Exception {
  const DealershipException();
}

final class MessageException extends DealershipException {
  final String exception;

  const MessageException(this.exception);

  @override
  String toString() => exception;
}

final class AuthRequiredException extends DealershipException {
  const AuthRequiredException();

  @override
  String toString() => 'User doesn\'t exist. Please sign in';
}

final class EmptyException extends DealershipException {
  const EmptyException();

  @override
  String toString() => '';
}
