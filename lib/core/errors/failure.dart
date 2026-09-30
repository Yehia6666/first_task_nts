abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  factory ServerFailure.fromDioError(String errorType) {
    switch (errorType) {
      case 'connectionTimeout':
      case 'sendTimeout':
      case 'receiveTimeout':
        return const ServerFailure('Connection timed out. Please try again.');
      case 'badResponse':
        return const ServerFailure('Server error. Please try again later.');
      case 'cancel':
        return const ServerFailure('Request was cancelled.');
      case 'noConnection':
        return const ServerFailure('No internet connection.');
      default:
        return const ServerFailure('An unexpected error occurred.');
    }
  }
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
