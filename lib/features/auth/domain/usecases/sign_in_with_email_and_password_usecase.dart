import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/core/usecases/usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';
import 'package:final_test_family_tree/features/auth/domain/repositories/auth_repository.dart';

class SignInWithEmailAndPasswordUseCase implements UseCase<UserEntity, Params<Map<String, String>>> {
  final AuthRepository repository;

  SignInWithEmailAndPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params<Map<String, String>> params) async {
    final email = params.data['email']!;
    final password = params.data['password']!;
    
    return await repository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
