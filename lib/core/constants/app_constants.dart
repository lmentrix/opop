/// MBTI app constants and configuration values
/// Contains app-wide constants used throughout the application
class AppConstants {
  // App Information
  static const String appName = 'MBTI Explorer';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Discover your personality type with our interactive MBTI assessment';

  // MBTI Personality Types
  static const List<String> mbtiTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP', // Analysts
    'INFJ', 'INFP', 'ENFJ', 'ENFP', // Diplomats
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ', // Sentinels
    'ISTP', 'ISFP', 'ESTP', 'ESFP', // Explorers
  ];

  // MBTI Categories
  static const Map<String, String> mbtiCategories = {
    'INTJ': 'Architect',
    'INTP': 'Logician',
    'ENTJ': 'Commander',
    'ENTP': 'Debater',
    'INFJ': 'Advocate',
    'INFP': 'Mediator',
    'ENFJ': 'Protagonist',
    'ENFP': 'Campaigner',
    'ISTJ': 'Logistician',
    'ISFJ': 'Defender',
    'ESTJ': 'Executive',
    'ESFJ': 'Consul',
    'ISTP': 'Virtuoso',
    'ISFP': 'Adventurer',
    'ESTP': 'Entrepreneur',
    'ESFP': 'Entertainer',
  };

  // MBTI Dimensions
  static const Map<String, List<String>> mbtiDimensions = {
    'E-I': ['Extraversion', 'Introversion'],
    'N-S': ['Intuition', 'Sensing'],
    'T-F': ['Thinking', 'Feeling'],
    'J-P': ['Judging', 'Perceiving'],
  };

  // Assessment Configuration
  static const int questionsPerDimension = 10;
  static const int totalQuestions = 40;
  static const Duration questionTimeout = Duration(seconds: 30);
  static const Duration transitionDuration = Duration(milliseconds: 300);

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 400);

  // UI Constants
  static const double maxCardWidth = 400.0;
  static const double minCardHeight = 200.0;
  static const double avatarSize = 80.0;
  static const double iconSize = 24.0;

  // Validation Constants
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minAge = 13;
  static const int maxAge = 25;

  // Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String assessmentResultsKey = 'assessment_results';
  static const String preferencesKey = 'user_preferences';
  static const String onboardingCompletedKey = 'onboarding_completed';

  // API Endpoints (if applicable)
  static const String baseUrl = 'https://api.mbtiexplorer.com';
  static const String assessmentEndpoint = '/assessment';
  static const String resultsEndpoint = '/results';
  static const String profileEndpoint = '/profile';

  // Error Messages
  static const String networkErrorMessage =
      'Please check your internet connection and try again.';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String validationErrorMessage =
      'Please check your input and try again.';

  // Success Messages
  static const String assessmentCompletedMessage =
      'Assessment completed! Here are your results.';
  static const String profileSavedMessage = 'Profile saved successfully!';
  static const String preferencesUpdatedMessage =
      'Preferences updated successfully!';

  // Onboarding Messages
  static const List<String> onboardingSteps = [
    'Welcome to MBTI Explorer!',
    'Discover your unique personality type',
    'Take our interactive assessment',
    'Get personalized insights and recommendations',
    'Connect with like-minded individuals',
  ];

  // Feature Flags
  static const bool enableSocialFeatures = true;
  static const bool enableNotifications = true;
  static const bool enableDataAnalytics = false;
  static const bool enableOfflineMode = true;

  // Performance Constants
  static const int maxCachedResults = 10;
  static const Duration cacheExpiration = Duration(days: 30);
  static const int maxImageCacheSize = 100;

  // Accessibility Constants
  static const double minTouchTargetSize = 48.0;
  static const double minContrastRatio = 4.5;
  static const Duration longPressDuration = Duration(milliseconds: 500);
}
