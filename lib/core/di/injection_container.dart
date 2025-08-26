// Core
import 'package:get_it/get_it';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Storage
import 'package:shared_preferences/shared_preferences.dart';

// Features - Auth
import 'package:final_test_family_tree/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:final_test_family_tree/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:final_test_family_tree/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:final_test_family_tree/features/auth/domain/repositories/auth_repository.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/register_with_email_and_password_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/send_otp_to_phone_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/sign_in_with_email_and_password_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:final_test_family_tree/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:final_test_family_tree/features/auth/presentation/providers/auth_provider.dart' as auth_provider;

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await _initFirebase();
  await _initSharedPreferences();

  // Data sources
  _initAuthDataSources();
  
  // Repositories
  _initRepositories();
  
  // Use cases
  _initAuthUseCases();
  
  // Providers
  _initProviders();
}

// Initialize Firebase services
Future<void> _initFirebase() async {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
}

// Initialize SharedPreferences
Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

// Initialize Auth Data Sources
void _initAuthDataSources() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      firebaseStorage: sl(),
    ),
  );
}

// Initialize Repositories
void _initRepositories() {
  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
}

// Initialize Auth Use Cases
void _initAuthUseCases() {
  // Check Auth Status
  sl.registerLazySingleton(
    () => CheckAuthStatusUseCase(authRepository: sl()),
  );
  
  // Sign In with Email and Password
  sl.registerLazySingleton(
    () => SignInWithEmailAndPasswordUseCase(authRepository: sl()),
  );
  
  // Register with Email and Password
  sl.registerLazySingleton(
    () => RegisterWithEmailAndPasswordUseCase(authRepository: sl()),
  );
  
  // Send OTP to Phone
  sl.registerLazySingleton(
    () => SendOtpToPhoneUseCase(authRepository: sl()),
  );
  
  // Verify OTP
  sl.registerLazySingleton(
    () => VerifyOtpUseCase(authRepository: sl()),
  );
  
  // Sign Out
  sl.registerLazySingleton(
    () => SignOutUseCase(authRepository: sl()),
  );
  
  // Forgot Password
  sl.registerLazySingleton(
    () => ForgotPasswordUseCase(authRepository: sl()),
  );
  
  // Update Profile
  sl.registerLazySingleton(
    () => UpdateProfileUseCase(authRepository: sl()),
  );
}

// Initialize Providers
void _initProviders() {
  // Auth Provider
  sl.registerFactory(
    () => auth_provider.AuthProvider(
      checkAuthStatusUseCase: sl(),
      signInWithEmailAndPasswordUseCase: sl(),
      registerWithEmailAndPasswordUseCase: sl(),
      sendOtpToPhoneUseCase: sl(),
      verifyOtpUseCase: sl(),
      signOutUseCase: sl(),
      forgotPasswordUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );
}
