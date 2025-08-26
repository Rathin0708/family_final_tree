import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/core/usecases/usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/repositories/auth_repository.dart';

class SendOtpToPhoneUseCase implements UseCase<String, Params<String>> {
  final AuthRepository repository;

  SendOtpToPhoneUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(Params<String> params) async {
    return await repository.sendOtpToPhone(phoneNumber: params.data);
  }
}
