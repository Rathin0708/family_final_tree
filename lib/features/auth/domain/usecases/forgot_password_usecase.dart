import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/core/usecases/usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, Params<String>> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Params<String> params) async {
    return await repository.forgotPassword(params.data);
  }
}
