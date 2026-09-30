import 'package:equatable/equatable.dart';

/// The account behind the token, as reported by the current-user endpoint.
class AuthenticatedUser extends Equatable {
  const AuthenticatedUser({
    required this.name,
    required this.email,
    this.id,
    this.phone,
    this.role,
    this.isActive = true,
    this.isDeleted = false,
    this.isEmailVerified,
  });

  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? role;

  /// False when the account is disabled, blocked, or pending.
  final bool isActive;

  final bool isDeleted;

  /// Null when the API does not report a verification flag.
  final bool? isEmailVerified;

  /// The fields the app cannot render a signed-in session without.
  bool get hasRequiredProfile => name.trim().isNotEmpty && email.trim().isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        role,
        isActive,
        isDeleted,
        isEmailVerified,
      ];
}
