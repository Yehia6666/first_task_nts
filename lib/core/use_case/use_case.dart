import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

abstract class UseCase<Success, Param> {
  const UseCase();

  Future<Either<Failure, Success>> call(Param param);
}

class NoParams {
  const NoParams();
}
