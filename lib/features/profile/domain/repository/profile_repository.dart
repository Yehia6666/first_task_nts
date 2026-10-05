import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile({required String token});
}