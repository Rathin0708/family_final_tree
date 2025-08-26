import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/core/usecases/usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';
import 'package:final_test_family_tree/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    try {
      final isAuthenticated = await repository.isAuthenticated();
      if (!isAuthenticated) {
        return const Right(null);
      }
      
      final user = await repository.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
