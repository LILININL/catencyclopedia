abstract class Failure {
  final String? message;

  Failure({this.message});
}

class ServerFailure extends Failure {
  ServerFailure({super.message});
}

class CacheFailure extends Failure {
  CacheFailure({super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({super.message});
}

class NotFoundFailure extends Failure {
  NotFoundFailure({super.message});
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure({super.message});
}

class BadRequestFailure extends Failure {
  BadRequestFailure({super.message});
}
