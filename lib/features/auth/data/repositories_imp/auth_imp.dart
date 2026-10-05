import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/database_validation.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/usecases/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImp implements AuthRepository {
  const AuthRepositoryImp(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, DatabaseValidation>> validateDatabase(
    String databaseUrl,
  ) async {
    try {
      final model = await _dataSource.validateDatabase(databaseUrl);
      return Right(model);
    } on DioException catch (e) {
      return Left(ServerFaliure.fromDioError(e));
    } catch (e) {
      return Left(ServerFaliure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _dataSource.signIn(
        email: email,
        password: password,
      );
      return Right(model);
    } on DioException catch (e) {
      return Left(ServerFaliure.fromDioError(e));
    } catch (e) {
      return Left(ServerFaliure(e.toString()));
    }
  }
}
