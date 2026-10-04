import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/database_validation.dart';
import 'auth_repository.dart';

class ValidateDatabaseUseCase extends UseCase<DatabaseValidation, String> {
  const ValidateDatabaseUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, DatabaseValidation>> call(String param) {
    return _repository.validateDatabase(param);
  }
}
