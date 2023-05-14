sealed class DealershipException implements Exception {
  const DealershipException();
}

final class MessageException extends DealershipException {
  final String exception;

  const MessageException(this.exception);

  @override
  String toString() => exception;
}

final class EmptyException extends DealershipException {
  const EmptyException();

  @override
  String toString() => '';
}


