/// Poll configuration data for MBTI Explorer app
/// Provides configuration options for poll creation
class PollData {
  /// Available MBTI types for poll targeting
  static const List<String> mbtiTypes = [
    'INTJ',
    'INTP',
    'ENTJ',
    'ENTP',
    'INFJ',
    'INFP',
    'ENFJ',
    'ENFP',
    'ISTJ',
    'ISFJ',
    'ESTJ',
    'ESFJ',
    'ISTP',
    'ISFP',
    'ESTP',
    'ESFP',
  ];

  /// Available moods for polls
  static const List<String> moods = [
    'thoughtful',
    'excited',
    'curious',
    'inspired',
    'grateful',
    'motivated',
    'reflective',
    'creative',
  ];

  /// Minimum number of poll options
  static const int minOptions = 2;

  /// Maximum number of poll options
  static const int maxOptions = 6;

  /// Minimum poll duration in hours
  static const int minDurationHours = 1;

  /// Maximum poll duration in hours (7 days)
  static const int maxDurationHours = 168;

  /// Default poll duration in hours
  static const int defaultDurationHours = 24;

  /// Default MBTI type
  static const String defaultMBTIType = 'INTJ';

  /// Default mood
  static const String defaultMood = 'thoughtful';

  /// Sample poll questions for MBTI context
  static const List<String> sampleQuestions = [
    'What\'s your biggest MBTI strength?',
    'Which cognitive function do you use most?',
    'What\'s your personality type\'s superpower?',
    'How do you prefer to recharge?',
    'What motivates you the most?',
    'What\'s your biggest challenge as your MBTI type?',
    'How do you make decisions?',
    'What\'s your ideal social situation?',
  ];

  /// Sample poll options for different contexts
  static const Map<String, List<String>> sampleOptions = {
    'strengths': [
      'Strategic thinking',
      'Empathy and understanding',
      'Creativity and innovation',
      'Organization and planning',
      'Adaptability and flexibility',
      'Leadership and guidance',
    ],
    'cognitive_functions': [
      'Introverted Thinking (Ti)',
      'Extraverted Thinking (Te)',
      'Introverted Feeling (Fi)',
      'Extraverted Feeling (Fe)',
      'Introverted Intuition (Ni)',
      'Extraverted Intuition (Ne)',
      'Introverted Sensing (Si)',
      'Extraverted Sensing (Se)',
    ],
    'superpowers': [
      'Seeing patterns and possibilities',
      'Creating harmony and understanding',
      'Building efficient systems',
      'Adapting to any situation',
      'Inspiring and motivating others',
      'Analyzing complex problems',
    ],
  };

  /// Get option label letter (A, B, C, etc.)
  static String getOptionLabel(int index) {
    return String.fromCharCode(65 + index); // A, B, C, etc.
  }

  /// Format duration for display
  static String formatDuration(int hours) {
    if (hours < 24) {
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      final days = hours ~/ 24;
      return '$days day${days > 1 ? 's' : ''}';
    }
  }

  /// Get sample options for a given context
  static List<String> getSampleOptions(String context) {
    return sampleOptions[context] ?? [];
  }

  /// Get random sample question
  static String getRandomSampleQuestion() {
    if (sampleQuestions.isEmpty) return 'What\'s on your mind?';

    final random = DateTime.now().millisecond % sampleQuestions.length;
    return sampleQuestions[random];
  }
}
