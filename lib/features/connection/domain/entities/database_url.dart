import 'package:equatable/equatable.dart';

class InvalidDatabaseUrlException implements Exception {
  const InvalidDatabaseUrlException(this.message);

  final String message;

  @override
  String toString() => message;
}

class DatabaseUrl extends Equatable {
  const DatabaseUrl._(this.value);

  final Uri value;

  factory DatabaseUrl.parse(String raw) {
    final String trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const InvalidDatabaseUrlException(
        'Enter the address of your Odoo server.',
      );
    }
    if (RegExp(r'\s').hasMatch(trimmed)) {
      throw const InvalidDatabaseUrlException(
        'The server address cannot contain spaces.',
      );
    }

    final String withScheme =
        trimmed.contains('://') ? trimmed : 'https://$trimmed';
    final Uri? uri = Uri.tryParse(withScheme);

    if (uri == null || !uri.hasAuthority) {
      throw const InvalidDatabaseUrlException(
        'This is not a valid server address.',
      );
    }
    if (uri.scheme != 'https') {
      throw const InvalidDatabaseUrlException(
        'The server address must use https://',
      );
    }
    if (uri.host.isEmpty || uri.host.contains('%')) {
      throw const InvalidDatabaseUrlException(
        'The server address is not a valid host name.',
      );
    }
    if (uri.userInfo.isNotEmpty) {
      throw const InvalidDatabaseUrlException(
        'Remove the username and password from the address; they are entered separately.',
      );
    }

    return DatabaseUrl._(
      Uri(
        scheme: uri.scheme,
        host: uri.host,
        port: uri.hasPort ? uri.port : null,
        path: uri.path == '/' ? '' : uri.path,
      ),
    );
  }

  String endpoint(String path) {
    final String base = value.toString().replaceFirst(RegExp(r'/+$'), '');
    return '$base/$path';
  }

  @override
  String toString() => value.toString();

  @override
  List<Object?> get props => [value];
}
