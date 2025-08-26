import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/core/errors/error_handler.dart';
import 'package:final_test_family_tree/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';
import 'package:final_test_family_tree/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await remoteDataSource.isAuthenticated();
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      throw ErrorHandler.handleError(e);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      final user = await remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );
      return Right(user);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtpToPhone({
    required String phoneNumber,
  }) async {
    try {
      final message = await remoteDataSource.sendOtpToPhone(
        phoneNumber: phoneNumber,
      );
      return Right(message);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      await remoteDataSource.verifyOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user) async {
    try {
      final updatedUser = await remoteDataSource.updateProfile(user);
      return Right(updatedUser);
    } catch (e) {
      return Left(ErrorHandler.handleError(e));
    }
  }
}
