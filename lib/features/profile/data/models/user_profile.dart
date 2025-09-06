/// User profile model for MBTI Explorer app
/// Contains user information, MBTI data, and achievements
class UserProfile {
  final String id;
  final String username;
  final String displayName;
  final String fullName;
  final String email;
  final String avatar;
  final String mbtiType;
  final String personalityDescription;
  final List<String> strengths;
  final List<String> weaknesses;
  final String location;
  final String joinDate;
  final String bio;
  final int assessmentCount;
  final int conversationCount;
  final int achievementCount;
  final List<Achievement> achievements;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.fullName,
    required this.email,
    required this.avatar,
    required this.mbtiType,
    required this.personalityDescription,
    required this.strengths,
    required this.weaknesses,
    required this.location,
    required this.joinDate,
    required this.bio,
    required this.assessmentCount,
    required this.conversationCount,
    required this.achievementCount,
    required this.achievements,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      mbtiType: json['mbtiType'] as String,
      personalityDescription: json['personalityDescription'] as String,
      strengths: List<String>.from(json['strengths'] as List),
      weaknesses: List<String>.from(json['weaknesses'] as List),
      location: json['location'] as String,
      joinDate: json['joinDate'] as String,
      bio: json['bio'] as String,
      assessmentCount: json['assessmentCount'] as int,
      conversationCount: json['conversationCount'] as int,
      achievementCount: json['achievementCount'] as int,
      achievements: (json['achievements'] as List)
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      preferences: Map<String, dynamic>.from(json['preferences'] as Map),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'fullName': fullName,
      'email': email,
      'avatar': avatar,
      'mbtiType': mbtiType,
      'personalityDescription': personalityDescription,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'location': location,
      'joinDate': joinDate,
      'bio': bio,
      'assessmentCount': assessmentCount,
      'conversationCount': conversationCount,
      'achievementCount': achievementCount,
      'achievements': achievements.map((e) => e.toJson()).toList(),
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated values
  UserProfile copyWith({
    String? id,
    String? username,
    String? displayName,
    String? fullName,
    String? email,
    String? avatar,
    String? mbtiType,
    String? personalityDescription,
    List<String>? strengths,
    List<String>? weaknesses,
    String? location,
    String? joinDate,
    String? bio,
    int? assessmentCount,
    int? conversationCount,
    int? achievementCount,
    List<Achievement>? achievements,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      mbtiType: mbtiType ?? this.mbtiType,
      personalityDescription:
          personalityDescription ?? this.personalityDescription,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      location: location ?? this.location,
      joinDate: joinDate ?? this.joinDate,
      bio: bio ?? this.bio,
      assessmentCount: assessmentCount ?? this.assessmentCount,
      conversationCount: conversationCount ?? this.conversationCount,
      achievementCount: achievementCount ?? this.achievementCount,
      achievements: achievements ?? this.achievements,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Generate dummy data for development
  factory UserProfile.dummyData() {
    return UserProfile(
      id: 'user_001',
      username: 'mbti_explorer',
      displayName: 'Alex Chen',
      fullName: 'Alexandra Chen',
      email: 'alex.chen@example.com',
      avatar: '👩‍💻',
      mbtiType: 'INTJ',
      personalityDescription:
          'The Architect - Imaginative and strategic thinkers, with a plan for everything.',
      strengths: [
        'Strategic thinking',
        'Independent',
        'Determined',
        'Open-minded',
        'Direct and honest',
      ],
      weaknesses: [
        'Overly analytical',
        'Perfectionist',
        'Impatient',
        'Arrogant',
        'Loathe highly structured environments',
      ],
      location: 'San Francisco, CA',
      joinDate: 'March 2024',
      bio:
          'Passionate about understanding personality types and helping others discover their true selves through MBTI insights.',
      assessmentCount: 3,
      conversationCount: 12,
      achievementCount: 5,
      achievements: [
        Achievement(
          id: 'ach_001',
          name: 'First Assessment',
          description: 'Completed your first MBTI assessment',
          icon: '🎯',
          color: 'analyst',
          unlockedAt: DateTime.now().subtract(Duration(days: 30)),
        ),
        Achievement(
          id: 'ach_002',
          name: 'Conversation Starter',
          description: 'Started 5 conversations',
          icon: '💬',
          color: 'diplomat',
          unlockedAt: DateTime.now().subtract(Duration(days: 25)),
        ),
        Achievement(
          id: 'ach_003',
          name: 'Personality Explorer',
          description: 'Explored all 16 personality types',
          icon: '🔍',
          color: 'explorer',
          unlockedAt: DateTime.now().subtract(Duration(days: 20)),
        ),
        Achievement(
          id: 'ach_004',
          name: 'Consistent Learner',
          description: 'Completed assessments for 7 consecutive days',
          icon: '📚',
          color: 'sentinel',
          unlockedAt: DateTime.now().subtract(Duration(days: 15)),
        ),
        Achievement(
          id: 'ach_005',
          name: 'MBTI Master',
          description: 'Achieved 100% accuracy in personality predictions',
          icon: '👑',
          color: 'primary',
          unlockedAt: DateTime.now().subtract(Duration(days: 10)),
        ),
      ],
      preferences: {
        'notifications': true,
        'privacy': 'public',
        'language': 'en_US',
        'theme': 'auto',
      },
      createdAt: DateTime.now().subtract(Duration(days: 45)),
      updatedAt: DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserProfile(id: $id, username: $username, mbtiType: $mbtiType)';
  }
}

/// Achievement model for user badges and accomplishments
class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final DateTime unlockedAt;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlockedAt,
  });

  /// Create Achievement from JSON
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
    );
  }

  /// Convert Achievement to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'unlockedAt': unlockedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Achievement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Achievement(id: $id, name: $name)';
  }
}
