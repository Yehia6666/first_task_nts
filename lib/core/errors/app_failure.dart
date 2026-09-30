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

/// Why the account behind a freshly issued token cannot be used.
enum AccountRejection {
  /// The token is unknown, expired, or refused by the server.
  sessionExpired,

  /// The account is disabled, blocked, or otherwise not active.
  accountDisabled,

  /// The account has been deleted or archived.
  accountDeleted,

  /// The server did not return the fields the app needs to open the shell.
  profileIncomplete,
}

/// The token was accepted at sign-in but the account behind it cannot be used.
/// The stored token must be dropped before anything else is attempted.
class AccountRejectedFailure extends AppFailure {
  const AccountRejectedFailure(super.message, {required this.reason});

  final AccountRejection reason;
}
