/// Chat conversation model for MBTI Explorer app
/// Represents a chat thread with multiple messages
class ChatConversation {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String lastSenderName;
  final String lastSenderAvatar;
  final int unreadCount;
  final List<String> participantIds;
  final ConversationType type;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatConversation({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastSenderName,
    required this.lastSenderAvatar,
    this.unreadCount = 0,
    required this.participantIds,
    required this.type,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create ChatConversation from JSON
  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] as String,
      title: json['title'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      lastSenderName: json['lastSenderName'] as String,
      lastSenderAvatar: json['lastSenderAvatar'] as String,
      unreadCount: json['unreadCount'] as int? ?? 0,
      participantIds: List<String>.from(json['participantIds'] as List),
      type: ConversationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ConversationType.personal,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert ChatConversation to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastSenderName': lastSenderName,
      'lastSenderAvatar': lastSenderAvatar,
      'unreadCount': unreadCount,
      'participantIds': participantIds,
      'type': type.name,
      if (metadata != null) 'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated values
  ChatConversation copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastSenderName,
    String? lastSenderAvatar,
    int? unreadCount,
    List<String>? participantIds,
    ConversationType? type,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastSenderName: lastSenderName ?? this.lastSenderName,
      lastSenderAvatar: lastSenderAvatar ?? this.lastSenderAvatar,
      unreadCount: unreadCount ?? this.unreadCount,
      participantIds: participantIds ?? this.participantIds,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatConversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChatConversation(id: $id, title: $title, lastMessage: $lastMessage, unreadCount: $unreadCount)';
  }
}

/// Conversation types for different chat categories
enum ConversationType {
  personal,
  group,
  support,
  assessment,
  personality,
  system,
}
