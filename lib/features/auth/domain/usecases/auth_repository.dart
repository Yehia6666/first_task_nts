import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/database_validation.dart';
import '../entities/login_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, DatabaseValidation>> validateDatabase(
    String databaseUrl,
  );

  Future<Either<Failure, LoginResponse>> signIn({
    required String email,
    required String password,
  });
}
