import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';
import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/register_with_email_and_password_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/send_otp_to_phone_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:final_test_family_tree/core/usecases/usecase.dart';

class AuthProvider with ChangeNotifier {
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  final RegisterWithEmailAndPasswordUseCase registerWithEmailAndPasswordUseCase;
  final SendOtpToPhoneUseCase sendOtpToPhoneUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final SignOutUseCase signOutUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  AuthProvider({
    required this.checkAuthStatusUseCase,
    required this.signInWithEmailAndPasswordUseCase,
    required this.registerWithEmailAndPasswordUseCase,
    required this.sendOtpToPhoneUseCase,
    required this.verifyOtpUseCase,
    required this.signOutUseCase,
    required this.forgotPasswordUseCase,
    required this.updateProfileUseCase,
  });

  bool _isLoading = false;
  bool _isAuthenticated = false;
  UserEntity? _user;
  String? _error;
  String? _verificationId;
  String? _phoneNumber;
  

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  UserEntity? get user => _user;
  String? get error => _error;
  String? get verificationId => _verificationId;
  String? get phoneNumber => _phoneNumber;

  // Setters
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setUser(UserEntity? user) {
    _user = user;
    _isAuthenticated = user != null;
    notifyListeners();
  }

  void _setVerificationId(String? verificationId) {
    _verificationId = verificationId;
    notifyListeners();
  }

  void _setPhoneNumber(String? phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    _setError(null);

    final result = await checkAuthStatusUseCase(NoParams());

    result.fold(
      (failure) {
        _setError(failure.message);
        _setUser(null);
      },
      (user) {
        _setUser(user);
      },
    );

    _setLoading(false);
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    final params = {
      'email': email.trim(),
      'password': password,
    };

    final result = await signInWithEmailAndPasswordUseCase(Params(params));

    bool success = false;

    result.fold(
      (failure) {
        _setError(failure.message);
        success = false;
      },
      (user) {
        _setUser(user);
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  // Register with email and password
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    _setError(null);

    final params = {
      'email': email.trim(),
      'password': password,
      'displayName': displayName.trim(),
      'phoneNumber': phoneNumber.trim(),
    };

    final result = await registerWithEmailAndPasswordUseCase(Params(params));

    bool success = false;

    result.fold(
      (failure) {
        _setError(failure.message);
        success = false;
      },
      (user) {
        _setUser(user);
        _setPhoneNumber(phoneNumber);
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  // Send OTP to phone
  Future<bool> sendOtpToPhone(String phoneNumber) async {
    _setLoading(true);
    _setError(null);
    _setPhoneNumber(phoneNumber);

    final result = await sendOtpToPhoneUseCase(Params(phoneNumber));

    bool success = false;

    result.fold(
      (failure) {
        _setError(failure.message);
        success = false;
      },
      (verificationId) {
        _setVerificationId(verificationId);
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  // Verify OTP
  Future<bool> verifyOtp(String smsCode) async {
    if (_verificationId == null) return false;

    _setLoading(true);
    _setError(null);

    final params = {
      'verificationId': _verificationId!,
      'smsCode': smsCode,
    };

    final result = await verifyOtpUseCase(Params(params));

    bool success = false;

    result.fold(
      (failure) {
        _setError(failure.message);
        success = false;
      },
      (_) {
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  // Sign out
  Future<bool> signOut() async {
    _setLoading(true);
    _setError(null);

    final result = await signOutUseCase(NoParams());

    bool success = false;

    result.fold(
      (failure) {
        _setError(failure.message);
        success = false;
      },
      (_) {
        _setUser(null);
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  // Forgot password
  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    _setError(null);

    final result = await forgotPasswordUseCase(Params(email));

    bool success = false;

    result.fold(
      (failure) {
        _setError(failure.message);
        success = false;
      },
      (_) {
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  // Update profile
  Future<bool> updateProfile(UserEntity user) async {
    _setLoading(true);
    _setError(null);

    final result = await updateProfileUseCase(Params(user));

    bool success = false;

    result.fold(
      (failure) {
        _setError(failure.message);
        success = false;
      },
      (updatedUser) {
        _setUser(updatedUser);
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  // Clear error
  void clearError() {
    _setError(null);
  }
}
