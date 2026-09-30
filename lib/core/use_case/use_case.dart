import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

abstract class UseCase<Success, Param> {
  Future<Either<Failure, Success>> call(Param param);
}
