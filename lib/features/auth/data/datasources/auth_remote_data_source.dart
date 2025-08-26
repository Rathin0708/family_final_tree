import 'package:dartz/dartz.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  // Check if user is authenticated
  Future<bool> isAuthenticated();

  // Get current user
  Future<UserEntity?> getCurrentUser();

  // Sign in with email and password
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Register with email and password
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  });

  // Send OTP to phone number
  Future<String> sendOtpToPhone({
    required String phoneNumber,
  });

  // Verify OTP
  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  // Sign out
  Future<void> signOut();

  // Forgot password
  Future<void> forgotPassword(String email);

  // Update user profile
  Future<UserEntity> updateProfile(UserEntity user);
}
