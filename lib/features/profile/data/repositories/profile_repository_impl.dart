import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImp implements ProfileRepository {
  const ProfileRepositoryImp(this._dataSource);

  final ProfileRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, Profile>> getProfile({required String token}) async {
    try {
      final model = await _dataSource.getProfile(token: token);
      return Right(model);
    } on DioException catch (e) {
      return Left(ServerFaliure.fromDioError(e));
    } catch (e) {
      return Left(ServerFaliure(e.toString()));
    }
  }
}