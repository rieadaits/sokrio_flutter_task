abstract class Failure {
  final String message;
  final int? statusCode;
  const Failure(this.message, this.statusCode);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, super.statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message, super.statusCode);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message, super.statusCode);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, super.statusCode);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, super.statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, super.statusCode);
}
