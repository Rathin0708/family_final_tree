import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_test_family_tree/core/constants/app_constants.dart';
import 'package:final_test_family_tree/features/auth/presentation/providers/auth_provider.dart';
import 'package:final_test_family_tree/features/auth/presentation/screens/login_screen.dart';
import 'package:final_test_family_tree/features/auth/presentation/screens/register_details_screen.dart';
import 'package:final_test_family_tree/features/auth/presentation/screens/register_password_screen.dart';
import 'package:final_test_family_tree/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:final_test_family_tree/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:final_test_family_tree/features/auth/presentation/screens/welcome_screen.dart';
import 'package:final_test_family_tree/features/dashboard/presentation/screens/dashboard_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth Routes
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      
      case RegisterDetailsScreen.routeName:
        return MaterialPageRoute(builder: (_) => const RegisterDetailsScreen());
      
      case RegisterPasswordScreen.routeName:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RegisterPasswordScreen(
            name: args['name'],
            email: args['email'],
            phone: args['phone'],
          ),
        );
      
      case kOtpVerificationRoute:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: args['phoneNumber'] ?? '',
            verificationId: args['verificationId'] ?? '',
            isRegistration: args['isRegistration'] ?? false,
          ),
        );
      
      case ForgotPasswordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      
      case WelcomeScreen.routeName:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      
      // Main App Routes
      case DashboardScreen.routeName:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      
      // Default Route
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        // Check if the user is authenticated
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isLoggedIn = authProvider.isAuthenticated;
        
        // Public routes that don't require authentication
        final publicRoutes = [
          LoginScreen.routeName,
          RegisterDetailsScreen.routeName,
          ForgotPasswordScreen.routeName,
        ];

        // If user is not logged in and trying to access a protected route
        if (!isLoggedIn && !publicRoutes.contains(settings.name)) {
          // Redirect to login without saving the route for now
          // We'll handle redirection after login in the LoginScreen
          return const LoginScreen();
        }

        // If user is logged in but trying to access auth screens
        if (isLoggedIn && publicRoutes.contains(settings.name)) {
          return const DashboardScreen();
        }

        // Otherwise, proceed with the requested route
        return Builder(
          builder: (context) => _buildRoute(settings, context),
        );
      },
    );
  }

  static Widget _buildRoute(RouteSettings settings, BuildContext context) {
    final route = settings.name;
    final args = settings.arguments;

    switch (route) {
      // Auth Routes
      case LoginScreen.routeName:
        return const LoginScreen();
      
      case RegisterDetailsScreen.routeName:
        return const RegisterDetailsScreen();
      
      case RegisterPasswordScreen.routeName:
        if (args is Map<String, dynamic>) {
          return RegisterPasswordScreen(
            name: args['name'] ?? '',
            email: args['email'] ?? '',
            phone: args['phone'] ?? '',
          );
        }
        return const LoginScreen();
      
      case kOtpVerificationRoute:
        if (args is Map<String, dynamic>) {
          return OtpVerificationScreen(
            phoneNumber: args['phoneNumber'] ?? '',
            verificationId: args['verificationId'] ?? '',
            isRegistration: args['isRegistration'] ?? false,
          );
        }
        return const LoginScreen();
      
      case ForgotPasswordScreen.routeName:
        return const ForgotPasswordScreen();
      
      case WelcomeScreen.routeName:
        return const WelcomeScreen();
      
      // Main App Routes
      case DashboardScreen.routeName:
        return const DashboardScreen();
      
      // Default Route
      default:
        return Scaffold(
          body: Center(
            child: Text('No route defined for $route'),
          ),
        );
    }
  }

  static String getInitialRoute() {
    // This can be enhanced to check for onboarding, authentication status, etc.
    return LoginScreen.routeName;
  }
}
