class AppConstants {
  // App
  static const String appName = 'Family Tree';
  
  // Routes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String otpVerificationRoute = '/otp-verification';
  static const String welcomeRoute = '/welcome';
  static const String homeRoute = '/home';
  
  // Collections
  static const String usersCollection = 'users';
  
  // Storage
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  
  // Messages
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternetConnection = 'No internet connection';
  static const String sessionExpired = 'Session expired. Please login again.';
  
  // Validation Messages
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidPhoneNumber = 'Please enter a valid phone number';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDontMatch = 'Passwords do not match';
  
  // Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImage = 'assets/images/placeholder.png';
}
