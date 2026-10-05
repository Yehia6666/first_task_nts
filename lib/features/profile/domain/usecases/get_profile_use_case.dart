import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../entities/profile.dart';
import '../repository/profile_repository.dart';

class GetProfileUseCase extends UseCase<Profile, String> {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Profile>> call(String param) {
    return _repository.getProfile(token: param);
  }
}