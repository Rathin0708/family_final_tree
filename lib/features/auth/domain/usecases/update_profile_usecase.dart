import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/core/usecases/usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';
import 'package:final_test_family_tree/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, Params<UserEntity>> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(Params<UserEntity> params) async {
    return await repository.updateProfile(params.data);
  }
}
