/// Post creation data for MBTI Explorer app
/// Provides configuration options for post creation
class PostCreationData {
  /// Available post types
  static const List<String> postTypes = ['text', 'image', 'video'];

  /// Available MBTI types
  static const List<String> mbtiTypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP',
    'INFJ', 'INFP', 'ENFJ', 'ENFP',
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
    'ISTP', 'ISFP', 'ESTP', 'ESFP',
  ];

  /// Available moods for posts
  static const List<String> moods = [
    'thoughtful',
    'excited',
    'curious',
    'inspired',
    'grateful',
    'motivated',
    'reflective',
    'creative',
    'energetic',
    'peaceful',
    'adventurous',
    'nostalgic',
  ];

  /// Default post type
  static const String defaultPostType = 'text';

  /// Default MBTI type
  static const String defaultMBTIType = 'INTJ';

  /// Default mood
  static const String defaultMood = 'thoughtful';

  /// Common hashtags for MBTI posts
  static const Map<String, List<String>> commonHashtags = {
    'INTJ': ['#INTJ', '#Strategic', '#Analytical', '#Visionary'],
    'INTP': ['#INTP', '#Logical', '#Innovative', '#Theorist'],
    'ENTJ': ['#ENTJ', '#Leadership', '#Decisive', '#Strategic'],
    'ENTP': ['#ENTP', '#Innovative', '#Debater', '#Visionary'],
    'INFJ': ['#INFJ', '#Empathetic', '#Insightful', '#Idealistic'],
    'INFP': ['#INFP', '#Creative', '#Empathetic', '#Idealistic'],
    'ENFJ': ['#ENFJ', '#Charismatic', '#Empathetic', '#Leadership'],
    'ENFP': ['#ENFP', '#Enthusiastic', '#Creative', '#Empathetic'],
    'ISTJ': ['#ISTJ', '#Reliable', '#Organized', '#Practical'],
    'ISFJ': ['#ISFJ', '#Caring', '#Supportive', '#Detail-oriented'],
    'ESTJ': ['#ESTJ', '#Organized', '#Leadership', '#Practical'],
    'ESFJ': ['#ESFJ', '#Caring', '#Supportive', '#Social'],
    'ISTP': ['#ISTP', '#Practical', '##Analytical', '#Independent'],
    'ISFP': ['#ISFP', '#Creative', '#Artistic', '#Gentle'],
    'ESTP': ['#ESTP', '#Energetic', '#Practical', '#Adventurous'],
    'ESFP': ['#ESFP', '#Enthusiastic', '#Social', '#Fun-loving'],
  };

  /// Suggested content prompts by MBTI type
  static const Map<String, List<String>> contentPrompts = {
    'INTJ': [
      'Just discovered a new system for...',
      'Strategic planning for the next quarter...',
      'My analysis of current trends...',
    ],
    'ENFP': [
      'Had the most amazing idea today...',
      'Anyone else get super excited about...',
      'Spontaneous adventure led to...',
    ],
    'ISTJ': [
      'Organized my workspace and productivity increased by...',
      'Following my daily routine helped me...',
      'Important reminder about deadlines...',
    ],
    'ESFP': [
      'Amazing time at the event today...',
      'Met some incredible people...',
      'Live in the moment and enjoy...',
    ],
  };

  /// Get default hashtags for MBTI type
  static List<String> getDefaultHashtags(String mbtiType) {
    return commonHashtags[mbtiType] ?? ['#MBTI', '#Personality'];
  }

  /// Get content prompts for MBTI type
  static List<String> getContentPrompts(String mbtiType) {
    return contentPrompts[mbtiType] ?? [
      'Sharing my thoughts on...',
      'Today I realized...',
      'Something interesting happened...',
    ];
  }

  /// Get random content prompt
  static String getRandomContentPrompt(String mbtiType) {
    final prompts = getContentPrompts(mbtiType);
    if (prompts.isEmpty) return 'What\'s on your mind?';
    
    final random = DateTime.now().millisecond % prompts.length;
    return prompts[random];
  }
}