import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/providers/auth_provider.dart' as auth_provider;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    // Initialize dependency injection
    await init();
  } catch (e) {
    debugPrint('Error initializing app: $e');
    rethrow;
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<auth_provider.AuthProvider>(
          create: (_) => sl<auth_provider.AuthProvider>()..checkAuthStatus(),
        ),
        // Add other providers here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.getInitialRoute(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      builder: (context, child) {
        // Add any app-wide configurations here
        final textTheme = Theme.of(context).textTheme;
        
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.poppinsTextTheme(textTheme),
          ),
          child: GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping outside of text fields
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && 
                  currentFocus.focusedChild != null) {
                currentFocus.focusedChild?.unfocus();
              }
            },
            child: child!,
          ),
        );
      },
    );
  }
}

// Error widget for better error visualization in development
class ErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  
  const ErrorWidget({
    Key? key,
    required this.errorDetails,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.red.shade50,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 64),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.red.shade900,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'re working on fixing this issue.\nPlease try again later.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // You might want to add a way to restart the app or go back
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
