import 'package:flutter/foundation.dart';
import 'dart:core';

import '../../../chat/data/models/chat_conversation.dart';

/// Simple friend profile data model for chat-based profiles
/// Contains only the basic information needed for friend profile display
class FriendProfile {
  final String id;
  final String name;
  final String avatar;
  final String mbtiType;
  final String? status;
  final DateTime? lastSeen;
  final int conversationCount;

  const FriendProfile({
    required this.id,
    required this.name,
    required this.avatar,
    required this.mbtiType,
    this.status,
    this.lastSeen,
    this.conversationCount = 0,
  });

  /// Create FriendProfile from conversation data
  factory FriendProfile.fromConversation(ChatConversation conversation) {
    // Extract MBTI type from title if present (e.g., "Sarah Chen (ENFP)")
    String mbtiType = 'INTJ'; // Default
    
    final mbtiMatch = RegExp(r'\((.*?)\)').firstMatch(conversation.title);
    if (mbtiMatch != null) {
      mbtiType = mbtiMatch.group(1) ?? 'INTJ';
    }

    return FriendProfile(
      id: 'friend_${conversation.id}',
      name: conversation.lastSenderName,
      avatar: conversation.lastSenderAvatar,
      mbtiType: mbtiType,
      status: 'Active',
      lastSeen: conversation.lastMessageTime,
      conversationCount: conversation.participantIds.length,
    );
  }

  /// Create FriendProfile from JSON
  factory FriendProfile.fromJson(Map<String, dynamic> json) {
    return FriendProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      mbtiType: json['mbtiType'] as String,
      status: json['status'] as String?,
      lastSeen: json['lastSeen'] != null 
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      conversationCount: json['conversationCount'] as int? ?? 0,
    );
  }

  /// Convert FriendProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'mbtiType': mbtiType,
      if (status != null) 'status': status,
      if (lastSeen != null) 'lastSeen': lastSeen!.toIso8601String(),
      'conversationCount': conversationCount,
    };
  }

  /// Get personality nickname
  String get personalityNickname {
    switch (mbtiType) {
      case 'INTJ':
        return 'The Architect';
      case 'INTP':
        return 'The Logician';
      case 'ENTJ':
        return 'The Commander';
      case 'ENTP':
        return 'The Debater';
      case 'INFJ':
        return 'The Advocate';
      case 'INFP':
        return 'The Mediator';
      case 'ENFJ':
        return 'The Protagonist';
      case 'ENFP':
        return 'The Campaigner';
      case 'ISTJ':
        return 'The Logistician';
      case 'ISFJ':
        return 'The Defender';
      case 'ESTJ':
        return 'The Executive';
      case 'ESFJ':
        return 'The Consul';
      case 'ISTP':
        return 'The Virtuoso';
      case 'ISFP':
        return 'The Adventurer';
      case 'ESTP':
        return 'The Entrepreneur';
      case 'ESFP':
        return 'The Entertainer';
      default:
        return 'The Explorer';
    }
  }

  /// Get personality description
  String get personalityDescription {
    switch (mbtiType) {
      case 'ENFP':
        return 'The Campaigner - Enthusiastic, creative and sociable free spirits.';
      case 'ENFJ':
        return 'The Protagonist - Charismatic and inspiring leaders, able to mesmerize their listeners.';
      case 'ISTP':
        return 'The Virtuoso - Bold and practical experimenters, masters of all kinds of tools.';
      case 'INTJ':
        return 'The Architect - Imaginative and strategic thinkers, with a plan for everything.';
      default:
        return 'A unique personality type with special insights and perspectives.';
    }
  }

  /// Get personality strengths
  List<String> get strengths {
    switch (mbtiType) {
      case 'ENFP':
        return ['Enthusiastic', 'Creative', 'Sociable', 'Empathetic', 'Spontaneous'];
      case 'ENFJ':
        return ['Charismatic', 'Inspiring', 'Empathetic', 'Organized', 'Altruistic'];
      case 'ISTP':
        return ['Practical', 'Observant', 'Logical', 'Adaptable', 'Independent'];
      case 'INTJ':
        return ['Strategic', 'Analytical', 'Independent', 'Determined', 'Insightful'];
      default:
        return ['Unique', 'Thoughtful', 'Authentic', 'Adaptable'];
    }
  }

  /// Get personality weaknesses
  List<String> get weaknesses {
    switch (mbtiType) {
      case 'ENFP':
        return ['Overly emotional', 'Unfocused', 'Disorganized', 'Restless'];
      case 'ENFJ':
        return ['Overly idealistic', 'Self-critical', 'Fluctuating self-esteem'];
      case 'ISTP':
        return ['Private', 'Insensitive', 'Easily bored', 'Risk-prone'];
      case 'INTJ':
        return ['Overly analytical', 'Perfectionistic', 'Impatient', 'Arrogant'];
      default:
        return ['Human', 'Learning', 'Growing'];
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FriendProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FriendProfile(id: $id, name: $name, mbtiType: $mbtiType)';
  }
}