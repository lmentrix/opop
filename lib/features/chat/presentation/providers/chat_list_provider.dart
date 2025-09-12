import 'package:flutter/material.dart';
import 'package:opop/features/chat/data/models/chat_conversation.dart';
import 'package:opop/features/chat/presentation/data/chat_friend_data.dart';

class ChatListProvider extends ChangeNotifier {
  final List<ChatConversation> _conversations = [];
  final List<ChatFriendClass> _friends = [];

  // Create chat state
  bool _isCreatingChat = false;
  String? _createChatError;
  bool _isCreatingPrivateChat = false;
  bool _isCreatingGroupChat = false;
  String? _creatingChatForUserId; // Track which user is being chatted with

  List<ChatConversation> get conversations => _conversations;
  bool get isCreatingChat => _isCreatingChat;
  String? get createChatError => _createChatError;
  bool get isCreatingPrivateChat => _isCreatingPrivateChat;
  bool get isCreatingGroupChat => _isCreatingGroupChat;
  String? get creatingChatForUserId => _creatingChatForUserId;

  void addConversation(ChatConversation conversation) {
    _conversations.add(conversation);
    notifyListeners();
  }

  void updateConversation(ChatConversation conversation) {
    final index = _conversations.indexWhere(
      (conv) => conv.id == conversation.id,
    );
    if (index != -1) {
      _conversations[index] = conversation;
      notifyListeners();
    }
  }

  void removeConversation(String conversationId) {
    final index = _conversations.indexWhere(
      (conv) => conv.id == conversationId,
    );
    if (index != -1) {
      _conversations.removeAt(index);
      notifyListeners();
    }
  }

  void clearConversations() {
    _conversations.clear();
    notifyListeners();
  }

  // Create chat state management methods
  void setCreatingChat(bool isCreating) {
    _isCreatingChat = isCreating;
    if (!isCreating) {
      _createChatError = null;
    }
    notifyListeners();
  }

  void setCreateChatError(String? error) {
    _createChatError = error;
    notifyListeners();
  }

  void setCreatingPrivateChat(bool isCreating) {
    _isCreatingPrivateChat = isCreating;
    notifyListeners();
  }

  void setCreatingGroupChat(bool isCreating) {
    _isCreatingGroupChat = isCreating;
    notifyListeners();
  }

  void resetCreateChatState() {
    _isCreatingChat = false;
    _createChatError = null;
    _isCreatingPrivateChat = false;
    _isCreatingGroupChat = false;
    _creatingChatForUserId = null;
    notifyListeners();
  }

  // Create group chat with detailed configuration
  Future<bool> createGroupChat({
    required String title,
    required List<String> participantIds,
    String? description,
    String? groupAvatar,
    bool isPrivate = false,
  }) async {
    setCreatingGroupChat(true);
    setCreateChatError(null);
    notifyListeners();

    try {
      // TODO: Implement actual API call to create group chat
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      final newConversation = ChatConversation(
        id: 'group_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        lastMessage: 'Group created',
        lastMessageTime: DateTime.now(),
        lastSenderName: 'You',
        lastSenderAvatar: groupAvatar ?? '',
        participantIds: participantIds,
        type: ConversationType.group,
        metadata: {
          'description': description,
          'isPrivate': isPrivate,
          'groupAvatar': groupAvatar,
          'adminId': 'current_user', // TODO: Get current user ID
          'createdAt': DateTime.now().toIso8601String(),
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      addConversation(newConversation);
      setCreatingGroupChat(false);
      notifyListeners();
      return true;
    } catch (e) {
      setCreateChatError('Failed to create group chat: ${e.toString()}');
      setCreatingGroupChat(false);
      notifyListeners();
      return false;
    }
  }

  // Create personal chat (1-on-1 conversation)
  Future<bool> createPersonalChat({
    required String userId,
    required String userName,
    required String userAvatar,
    String? userMbti,
  }) async {
    _creatingChatForUserId = userId;
    setCreatingPrivateChat(true);
    setCreateChatError(null);
    notifyListeners();

    try {
      // TODO: Implement actual API call to create personal chat
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      final newConversation = ChatConversation(
        id: 'personal_${DateTime.now().millisecondsSinceEpoch}',
        title: userName,
        lastMessage: 'Conversation started',
        lastMessageTime: DateTime.now(),
        lastSenderName: 'You',
        lastSenderAvatar: userAvatar,
        participantIds: [userId],
        type: ConversationType.personal,
        metadata: {
          'userMbti': userMbti,
          'isOnline': true, // TODO: Get actual online status
          'lastSeen': DateTime.now().toIso8601String(),
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      addConversation(newConversation);
      setCreatingPrivateChat(false);
      _creatingChatForUserId = null;
      notifyListeners();
      return true;
    } catch (e) {
      setCreateChatError('Failed to create personal chat: ${e.toString()}');
      setCreatingPrivateChat(false);
      _creatingChatForUserId = null;
      notifyListeners();
      return false;
    }
  }

  // Create support chat with customer service
  Future<bool> createSupportChat({
    String? subject,
    String? category,
    String? priority = 'normal',
  }) async {
    _isCreatingChat = true;
    setCreateChatError(null);
    notifyListeners();

    try {
      // TODO: Implement actual API call to create support chat
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      final newConversation = ChatConversation(
        id: 'support_${DateTime.now().millisecondsSinceEpoch}',
        title: subject ?? 'Support Request',
        lastMessage: 'Support ticket created. How can we help you?',
        lastMessageTime: DateTime.now(),
        lastSenderName: 'Support Team',
        lastSenderAvatar: '🎧',
        participantIds: ['support_team'],
        type: ConversationType.support,
        metadata: {
          'category': category ?? 'general',
          'priority': priority,
          'status': 'open',
          'ticketId': 'TCK${DateTime.now().millisecondsSinceEpoch}',
          'assignedAgent': 'unassigned',
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      addConversation(newConversation);
      _isCreatingChat = false;
      notifyListeners();
      return true;
    } catch (e) {
      setCreateChatError('Failed to create support chat: ${e.toString()}');
      _isCreatingChat = false;
      notifyListeners();
      return false;
    }
  }

  // Legacy method for backward compatibility
  Future<bool> createPrivateChat(
    String participantId,
    String participantName,
    String participantAvatar,
  ) async {
    return createPersonalChat(
      userId: participantId,
      userName: participantName,
      userAvatar: participantAvatar,
    );
  }
}
