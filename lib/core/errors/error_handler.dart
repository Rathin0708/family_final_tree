import 'package:flutter/foundation.dart';
import 'package:final_test_family_tree/core/errors/failures.dart';

class ErrorHandler {
  static Failure handleError(dynamic error, [StackTrace? stackTrace]) {
    debugPrint('Error: $error');
    debugPrint('Stack trace: $stackTrace');

    if (error is Failure) {
      return error;
    } else if (error is FormatException) {
      return const ValidationFailure('Invalid data format');
    } else if (error is TypeError) {
      return const ValidationFailure('Type error occurred');
    } else if (error is ArgumentError) {
      return ValidationFailure(error.message);
    } else if (error is NoSuchMethodError) {
      return const ValidationFailure('Requested method not found');
    } else if (error.toString().contains('SocketException') ||
        error.toString().contains('Network is unreachable')) {
      return const NetworkFailure('No internet connection');
    } else if (error.toString().contains('TimeoutException')) {
      return const TimeoutFailure('Request timed out');
    } else if (error.toString().contains('PlatformException')) {
      return const ServerFailure('Platform exception occurred');
    } else if (error.toString().contains('FirebaseException')) {
      return _handleFirebaseError(error);
    } else {
      return const UnknownFailure('An unknown error occurred');
    }
  }

  static Failure _handleFirebaseError(dynamic error) {
    final errorCode = error.code?.toLowerCase() ?? '';
    final errorMessage = error.message?.toString() ?? 'An error occurred with Firebase';

    switch (errorCode) {
      case 'user-not-found':
        return const AuthenticationFailure('No user found with this email');
      case 'wrong-password':
        return const AuthenticationFailure('Incorrect password');
      case 'user-disabled':
        return const AuthenticationFailure('This account has been disabled');
      case 'too-many-requests':
        return const AuthenticationFailure('Too many attempts. Please try again later');
      case 'operation-not-allowed':
        return const AuthenticationFailure('This operation is not allowed');
      case 'invalid-email':
        return const ValidationFailure('Invalid email address');
      case 'email-already-in-use':
        return const ValidationFailure('Email is already in use');
      case 'weak-password':
        return const ValidationFailure('Password is too weak');
      case 'invalid-verification-code':
      case 'invalid-verification-id':
        return const ValidationFailure('Invalid verification code');
      case 'network-request-failed':
        return const NetworkFailure('Network error occurred');
      case 'requires-recent-login':
        return const AuthenticationFailure('Please login again to perform this action');
      default:
        return ServerFailure(errorMessage);
    }
  }
}
