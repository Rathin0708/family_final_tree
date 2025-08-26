import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  // Check if user is authenticated
  Future<bool> isAuthenticated();

  // Get current user
  Future<UserEntity?> getCurrentUser();

  // Sign in with email and password
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Register with email and password
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  });

  // Send OTP to phone number
  Future<Either<Failure, String>> sendOtpToPhone({
    required String phoneNumber,
  });

  // Verify OTP
  Future<Either<Failure, void>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  // Sign out
  Future<Either<Failure, void>> signOut();

  // Forgot password
  Future<Either<Failure, void>> forgotPassword(String email);

  // Update user profile
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user);
}
