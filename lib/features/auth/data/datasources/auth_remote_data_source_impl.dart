import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:final_test_family_tree/core/constants/app_constants.dart';
import 'package:final_test_family_tree/features/auth/data/models/user_model.dart';
import 'package:final_test_family_tree/features/auth/domain/entities/user_entity.dart';
import 'auth_remote_data_source.dart';

class FirebaseAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  // ignore: unused_field - Used in _uploadFile method
  final firebase_storage.FirebaseStorage _firebaseStorage;

  FirebaseAuthRemoteDataSourceImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    firebase_storage.FirebaseStorage? firebaseStorage,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? firebase_storage.FirebaseStorage.instance;

  @override
  Future<bool> isAuthenticated() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        return null;
      }

      return UserModel.fromJson(userDoc.data()!..['id'] = user.uid);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final token = await userCredential.user!.getIdToken();
      return UserModel.fromFirebaseUser(userCredential.user!, token: token);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      // Create user with email and password
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user!.updateDisplayName(displayName);

      // Create user data in Firestore
      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        displayName: displayName,
        phoneNumber: phoneNumber,
        emailVerified: false,
        isAnonymous: false,
        createdAt: DateTime.now(),
        lastSignInTime: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .set(user.toJson());

      // Get ID token
      final token = await userCredential.user!.getIdToken();
      return user.copyWith(token: token);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> sendOtpToPhone({required String phoneNumber}) async {
    try {
      // Format phone number if needed
      final formattedPhoneNumber = phoneNumber.startsWith('+')
          ? phoneNumber
          : '+$phoneNumber';

      // Start phone number verification
      final verificationCompleted = (firebase_auth.PhoneAuthCredential credential) async {
        // Auto-verification completed
      };

      final verificationFailed = (firebase_auth.FirebaseAuthException e) {
        throw _handleFirebaseAuthException(e);
      };

      final codeSent = (String verificationId, int? resendToken) async {
        // Verification code sent
      };

      final codeAutoRetrievalTimeout = (String verificationId) {
        // Auto-resolution timed out
      };

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: formattedPhoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      return 'OTP sent to $formattedPhoneNumber';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Uploads a file to Firebase Storage and returns the download URL
  Future<String?> _uploadFile(File file, String path) async {
    try {
      final ref = _firebaseStorage.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading file to Firebase Storage: $e');
      return null;
    }
  }

  @override
  Future<UserEntity> updateProfile(UserEntity user) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw firebase_auth.FirebaseAuthException(
          code: 'unauthenticated',
          message: 'User is not authenticated',
        );
      }

      // If there's a new profile picture, upload it to Firebase Storage
      if (user.profilePicture != null && user.profilePicture!.startsWith('file:')) {
        try {
          final file = File(user.profilePicture!.replaceFirst('file:', ''));
          if (await file.exists()) {
            final downloadUrl = await _uploadFile(
              file,
              'profile_pictures/${currentUser.uid}.jpg',
            );
            
            if (downloadUrl != null) {
              user = user.copyWith(profilePicture: downloadUrl);
            } else {
              debugPrint('Failed to upload profile picture');
            }
          }
        } catch (e) {
          debugPrint('Error processing profile picture: $e');
          // Continue without updating the profile picture if upload fails
        }
      }

      // Update user data in Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .update(user.toJson());

      // Fetch the updated user data
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('Failed to fetch updated user data');
      }

      return UserModel.fromJson(userDoc.data()!..['id'] = currentUser.uid);
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to handle Firebase Auth exceptions
  Exception _handleFirebaseAuthException(
      firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'user-disabled':
        return Exception('This account has been disabled');
      case 'too-many-requests':
        return Exception('Too many requests. Please try again later');
      case 'operation-not-allowed':
        return Exception('This operation is not allowed');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'email-already-in-use':
        return Exception('Email is already in use');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-verification-code':
      case 'invalid-verification-id':
        return Exception('Invalid verification code');
      case 'network-request-failed':
        return Exception('Network error occurred');
      case 'requires-recent-login':
        return Exception('Please login again to perform this action');
      default:
        return Exception(e.message ?? 'An unknown error occurred');
    }
  }
}
