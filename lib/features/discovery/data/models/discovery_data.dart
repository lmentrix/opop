import 'dart:ui';

/// Discovery post data model for MBTI Explorer app
/// Represents posts, stories, and content in the discovery feed
class DiscoveryPost {
  final String id;
  final String username;
  final String mbtiType;
  final String avatar;
  final String timeAgo;
  final String postType;
  final String content;
  final String? videoThumbnail;
  final String? imageThumbnail;
  final int likes;
  final int comments;
  final int shares;
  final List<Color> gradient;
  final List<String> hashtags;
  final bool isLiked;
  final bool isBookmarked;

  DiscoveryPost({
    required this.id,
    required this.username,
    required this.mbtiType,
    required this.avatar,
    required this.timeAgo,
    required this.postType,
    required this.content,
    this.videoThumbnail,
    this.imageThumbnail,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.gradient,
    required this.hashtags,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  factory DiscoveryPost.fromJson(Map<String, dynamic> json) {
    return DiscoveryPost(
      id: json['id'],
      username: json['username'],
      mbtiType: json['mbtiType'],
      avatar: json['avatar'],
      timeAgo: json['timeAgo'],
      postType: json['postType'],
      content: json['content'],
      videoThumbnail: json['videoThumbnail'],
      imageThumbnail: json['imageThumbnail'],
      likes: json['likes'],
      comments: json['comments'],
      shares: json['shares'],
      gradient: List<Color>.from(json['gradient']),
      hashtags: List<String>.from(json['hashtags']),
      isLiked: json['isLiked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'mbtiType': mbtiType,
      'avatar': avatar,
      'timeAgo': timeAgo,
      'postType': postType,
      'content': content,
      'videoThumbnail': videoThumbnail,
      'imageThumbnail': imageThumbnail,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'gradient': gradient,
      'hashtags': hashtags,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }

  DiscoveryPost copyWith({
    String? id,
    String? username,
    String? mbtiType,
    String? avatar,
    String? timeAgo,
    String? postType,
    String? content,
    String? videoThumbnail,
    String? imageThumbnail,
    int? likes,
    int? comments,
    int? shares,
    List<Color>? gradient,
    List<String>? hashtags,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return DiscoveryPost(
      id: id ?? this.id,
      username: username ?? this.username,
      mbtiType: mbtiType ?? this.mbtiType,
      avatar: avatar ?? this.avatar,
      timeAgo: timeAgo ?? this.timeAgo,
      postType: postType ?? this.postType,
      content: content ?? this.content,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      imageThumbnail: imageThumbnail ?? this.imageThumbnail,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      gradient: gradient ?? this.gradient,
      hashtags: hashtags ?? this.hashtags,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  /// Returns an empty DiscoveryPost instance
  static DiscoveryPost empty() {
    return DiscoveryPost(
      id: '',
      username: '',
      mbtiType: '',
      avatar: '',
      timeAgo: '',
      postType: '',
      content: '',
      likes: 0,
      comments: 0,
      shares: 0,
      gradient: [],
      hashtags: [],
      isLiked: false,
      isBookmarked: false,
    );
  }
}

/// Discovery potential match data model
class DiscoveryMatch {
  final String name;
  final String mbtiType;
  final String avatar;
  final int compatibility;
  final String distance;
  final List<String> interests;
  final List<Color> gradient;
  final String description;

  DiscoveryMatch({
    required this.name,
    required this.mbtiType,
    required this.avatar,
    required this.compatibility,
    required this.distance,
    required this.interests,
    required this.gradient,
    required this.description,
  });

  factory DiscoveryMatch.fromJson(Map<String, dynamic> json) {
    return DiscoveryMatch(
      name: json['name'],
      mbtiType: json['mbtiType'],
      avatar: json['avatar'],
      compatibility: json['compatibility'],
      distance: json['distance'],
      interests: List<String>.from(json['interests']),
      gradient: List<Color>.from(json['gradient']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mbtiType': mbtiType,
      'avatar': avatar,
      'compatibility': compatibility,
      'distance': distance,
      'interests': interests,
      'gradient': gradient,
      'description': description,
    };
  }
}

/// Discovery data provider with static methods
class DiscoveryData {
  static List<DiscoveryPost> getDummyPosts() {
    return [
      DiscoveryPost(
        id: '1',
        username: 'Alex Chen',
        mbtiType: 'INTJ',
        avatar: '👩‍💻',
        timeAgo: '2h',
        postType: 'video',
        content:
            'Just discovered my cognitive functions! Te-Ni-Se-Fi makes so much sense now 🧠✨',
        videoThumbnail: '🎬',
        likes: 247,
        comments: 18,
        shares: 5,
        gradient: [
          const Color(0xFF9C27B0),
          const Color(0xFF9C27B0).withOpacity(0.7),
        ],
        hashtags: ['#INTJ', '#CognitiveFunctions', '#PersonalityGrowth'],
      ),
      DiscoveryPost(
        id: '2',
        username: 'Sarah Martinez',
        mbtiType: 'ENFP',
        avatar: '🎨',
        timeAgo: '4h',
        postType: 'text',
        content:
            'MBTI types as colors: INFJ is deep purple, ENFP is bright orange, INTJ is midnight blue. What color represents your type? 🎨',
        likes: 189,
        comments: 32,
        shares: 12,
        gradient: [
          const Color(0xFF00BCD4),
          const Color(0xFF00BCD4).withOpacity(0.7),
        ],
        hashtags: ['#MBTI', '#Colors', '#PersonalityTypes'],
      ),
      DiscoveryPost(
        id: '3',
        username: 'Marcus Rodriguez',
        mbtiType: 'ENTP',
        avatar: '🔬',
        timeAgo: '6h',
        postType: 'image',
        content:
            'Experimenting with different personality combinations. The dynamics between Ti-Ne and Fe-Si are fascinating!',
        imageThumbnail: '📊',
        likes: 156,
        comments: 24,
        shares: 8,
        gradient: [const Color(0xFF00BCD4), const Color(0xFF2196F3)],
        hashtags: ['#ENTP', '#CognitiveFunctions', '#Psychology'],
      ),
      DiscoveryPost(
        id: '4',
        username: 'Emily Watson',
        mbtiType: 'ISFP',
        avatar: '🎵',
        timeAgo: '8h',
        postType: 'music',
        content:
            'Created a playlist that perfectly captures the ISFP vibe - gentle, artistic, and deeply emotional 🎶',
        likes: 298,
        comments: 45,
        shares: 23,
        gradient: [
          const Color(0xFF4CAF50),
          const Color(0xFF4CAF50).withOpacity(0.7),
        ],
        hashtags: ['#ISFP', '#Music', '#Playlists'],
      ),
      DiscoveryPost(
        id: '5',
        username: 'David Kim',
        mbtiType: 'INTJ',
        avatar: '📚',
        timeAgo: '1d',
        postType: 'text',
        content:
            'Strategic planning for the year ahead. INTJ strengths in long-term vision and systematic thinking are invaluable. 🎯',
        likes: 312,
        comments: 28,
        shares: 15,
        gradient: [
          const Color(0xFF9C27B0),
          const Color(0xFF9C27B0).withOpacity(0.7),
        ],
        hashtags: ['#INTJ', '#StrategicPlanning', '#PersonalDevelopment'],
      ),
    ];
  }

  static List<DiscoveryMatch> getDummyMatches() {
    return [
      DiscoveryMatch(
        name: 'Sarah Chen',
        mbtiType: 'ENFP',
        avatar: '🎨',
        compatibility: 95,
        distance: '2.3 km away',
        interests: ['Art', 'Psychology', 'Travel'],
        gradient: [
          const Color(0xFF00BCD4),
          const Color(0xFF00BCD4).withOpacity(0.7),
        ],
        description:
            'Creative soul who loves deep conversations about personality types',
      ),
      DiscoveryMatch(
        name: 'Alex Rodriguez',
        mbtiType: 'INFJ',
        avatar: '📚',
        compatibility: 88,
        distance: '5.1 km away',
        interests: ['Books', 'Philosophy', 'Music'],
        gradient: [const Color(0xFF00BCD4), const Color(0xFF9C27B0)],
        description:
            'Empathetic listener with a passion for understanding human behavior',
      ),
      DiscoveryMatch(
        name: 'Maya Patel',
        mbtiType: 'ENTJ',
        avatar: '💼',
        compatibility: 82,
        distance: '3.8 km away',
        interests: ['Business', 'Leadership', 'Innovation'],
        gradient: [const Color(0xFF00BCD4), const Color(0xFF2196F3)],
        description: 'Ambitious leader with strategic vision and people skills',
      ),
      DiscoveryMatch(
        name: 'James Wilson',
        mbtiType: 'INFP',
        avatar: '🌟',
        compatibility: 79,
        distance: '1.2 km away',
        interests: ['Writing', 'Nature', 'Spirituality'],
        gradient: [
          const Color(0xFF9C27B0),
          const Color(0xFF9C27B0).withOpacity(0.7),
        ],
        description: 'Dreamer and idealist seeking meaningful connections',
      ),
    ];
  }
}
