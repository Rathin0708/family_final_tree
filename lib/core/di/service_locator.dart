// Core
import 'package:get_it/get_it.dart';

// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  await Firebase.initializeApp();
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      firebaseStorage: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithEmailAndPasswordUseCase(sl()));
  sl.registerLazySingleton(() => RegisterWithEmailAndPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SendOtpToPhoneUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Providers
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
