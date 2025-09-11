import '../models/chat_conversation.dart';
import '../models/chat_message.dart';

/// Dummy data source for chat conversations
/// This can easily be replaced with real API calls or JSON data
class ChatDummyData {
  static List<ChatConversation> getConversations() {
    return [
      ChatConversation(
        id: '1',
        title: 'MBTI Assessment Bot',
        lastMessage:
            'Ready to discover your personality type? Let\'s start the assessment!',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        lastSenderName: 'MBTI Bot',
        lastSenderAvatar: '🤖',
        unreadCount: 1,
        participantIds: ['user', 'bot'],
        type: ConversationType.assessment,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatConversation(
        id: '2',
        title: 'Personality Insights',
        lastMessage: 'Based on your results, you might enjoy careers in...',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        lastSenderName: 'Insights Bot',
        lastSenderAvatar: '💡',
        unreadCount: 0,
        participantIds: ['user', 'insights'],
        type: ConversationType.personality,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatConversation(
        id: '3',
        title: 'Sarah Chen (ENFP)',
        lastMessage:
            'That\'s so interesting! I never thought about it that way.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        lastSenderName: 'Sarah Chen',
        lastSenderAvatar: '👩‍🦰',
        unreadCount: 2,
        participantIds: ['user', 'sarah'],
        type: ConversationType.personal,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ChatConversation(
        id: '4',
        title: 'MBTI Study Group',
        lastMessage: 'Next meeting: Discussing cognitive functions',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        lastSenderName: 'Alex (INTJ)',
        lastSenderAvatar: '👨‍💼',
        unreadCount: 5,
        participantIds: ['user', 'alex', 'maria', 'james', 'lisa'],
        type: ConversationType.group,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ChatConversation(
        id: '5',
        title: 'Customer Support',
        lastMessage: 'Your issue has been resolved. Is there anything else?',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
        lastSenderName: 'Support Team',
        lastSenderAvatar: '🆘',
        unreadCount: 0,
        participantIds: ['user', 'support'],
        type: ConversationType.support,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ChatConversation(
        id: '6',
        title: 'Daily Personality Tip',
        lastMessage:
            'Today\'s tip: Practice active listening to improve your relationships!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        lastSenderName: 'Tips Bot',
        lastSenderAvatar: '💭',
        unreadCount: 0,
        participantIds: ['user', 'tips'],
        type: ConversationType.system,
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ChatConversation(
        id: '7',
        title: 'Marcus Johnson (ISTP)',
        lastMessage: 'Thanks for the recommendation!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
        lastSenderName: 'Marcus Johnson',
        lastSenderAvatar: '👨‍🔧',
        unreadCount: 0,
        participantIds: ['user', 'marcus'],
        type: ConversationType.personal,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ChatConversation(
        id: '8',
        title: 'Career Guidance',
        lastMessage:
            'Let\'s explore career paths that match your personality type.',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 4)),
        lastSenderName: 'Career Bot',
        lastSenderAvatar: '🎯',
        unreadCount: 0,
        participantIds: ['user', 'career'],
        type: ConversationType.personality,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      ChatConversation(
        id: '9',
        title: 'Emma Wilson (ENFJ)',
        lastMessage:
            'Hey! Did you see the new personality test results? Super excited to discuss!',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        lastSenderName: 'Emma Wilson',
        lastSenderAvatar: '👩‍💻',
        unreadCount: 12,
        participantIds: ['user', 'emma'],
        type: ConversationType.personal,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  static List<ChatMessage> getMessagesForConversation(String conversationId) {
    switch (conversationId) {
      case '1': // MBTI Assessment Bot
        return [
          ChatMessage(
            id: '1_1',
            senderId: 'bot',
            senderName: 'MBTI Bot',
            senderAvatar: '🤖',
            content:
                'Hello! I\'m here to help you discover your MBTI personality type.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            type: MessageType.text,
            isRead: true,
          ),
          ChatMessage(
            id: '1_2',
            senderId: 'user',
            senderName: 'You',
            senderAvatar: '👤',
            content: 'Hi! I\'d like to take the assessment.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
            type: MessageType.text,
            isRead: true,
          ),
          ChatMessage(
            id: '1_3',
            senderId: 'bot',
            senderName: 'MBTI Bot',
            senderAvatar: '🤖',
            content:
                'Great! The assessment consists of 40 questions that will help determine your preferences in four key areas: Extraversion vs Introversion, Sensing vs Intuition, Thinking vs Feeling, and Judging vs Perceiving.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
            type: MessageType.text,
            isRead: true,
          ),
          ChatMessage(
            id: '1_4',
            senderId: 'user',
            senderName: 'You',
            senderAvatar: '👤',
            content: 'Sounds good! How long will it take?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
            type: MessageType.text,
            isRead: true,
          ),
          ChatMessage(
            id: '1_5',
            senderId: 'bot',
            senderName: 'MBTI Bot',
            senderAvatar: '🤖',
            content:
                'The assessment typically takes 15-20 minutes. You can pause and resume at any time. Ready to discover your personality type? Let\'s start the assessment!',
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            type: MessageType.text,
            isRead: false,
          ),
        ];

      case '2': // Personality Insights
        return [
          ChatMessage(
            id: '2_1',
            senderId: 'insights',
            senderName: 'Insights Bot',
            senderAvatar: '💡',
            content:
                'Based on your MBTI results, here are some career paths that might interest you...',
            timestamp: DateTime.now().subtract(const Duration(hours: 3)),
            type: MessageType.personalityResult,
            isRead: true,
          ),
          ChatMessage(
            id: '2_2',
            senderId: 'user',
            senderName: 'You',
            senderAvatar: '👤',
            content:
                'This is really helpful! Can you tell me more about my strengths?',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: MessageType.text,
            isRead: true,
          ),
          ChatMessage(
            id: '2_3',
            senderId: 'insights',
            senderName: 'Insights Bot',
            senderAvatar: '💡',
            content:
                'Based on your results, you might enjoy careers in psychology, counseling, teaching, or creative fields. Your natural empathy and insight make you excellent at understanding others.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: MessageType.text,
            isRead: true,
          ),
        ];

      default:
        return [
          ChatMessage(
            id: 'default_1',
            senderId: 'system',
            senderName: 'System',
            senderAvatar: '⚙️',
            content: 'This conversation is loading...',
            timestamp: DateTime.now(),
            type: MessageType.system,
            isRead: true,
          ),
        ];
    }
  }

  /// Get conversation by ID
  static ChatConversation? getConversationById(String id) {
    try {
      return getConversations().firstWhere((conv) => conv.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search conversations by title or content
  static List<ChatConversation> searchConversations(String query) {
    final conversations = getConversations();
    if (query.isEmpty) return conversations;

    return conversations.where((conv) {
      return conv.title.toLowerCase().contains(query.toLowerCase()) ||
          conv.lastMessage.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Get conversations by type
  static List<ChatConversation> getConversationsByType(ConversationType type) {
    return getConversations().where((conv) => conv.type == type).toList();
  }

  /// Get unread conversations count
  static int getUnreadCount() {
    return getConversations().fold(0, (sum, conv) => sum + conv.unreadCount);
  }
}
