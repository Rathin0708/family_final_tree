import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/core/usecases/usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase implements UseCase<void, Params<Map<String, String>>> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(Params<Map<String, String>> params) async {
    final verificationId = params.data['verificationId']!;
    final smsCode = params.data['smsCode']!;
    
    return await repository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
