import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class Params<T> {
  final T data;

  Params(this.data);
}
