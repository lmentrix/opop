import 'package:flutter/material.dart';
import 'package:opop/features/chat/data/models/chat_conversation.dart';

class ChatListProvider extends ChangeNotifier {
  final List<ChatConversation> _conversations = [];

  List<ChatConversation> get conversations => _conversations;

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
}
