sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([
    super.message =
        'Could not reach the server. Check the address and your internet connection.',
  ]);
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure([
    super.message =
        'The server took too long to answer. Check the address and try again.',
  ]);
}

class ServerRequestFailure extends AppFailure {
  const ServerRequestFailure(super.message, {required this.statusCode});

  final int statusCode;
}

class ServerValidationFailure extends AppFailure {
  const ServerValidationFailure(super.message, {this.code});

  final String? code;
}

class UnexpectedResponseFailure extends AppFailure {
  const UnexpectedResponseFailure([
    super.message =
        'The server replied with an unexpected response. Make sure the address points to an Odoo server.',
  ]);
}
