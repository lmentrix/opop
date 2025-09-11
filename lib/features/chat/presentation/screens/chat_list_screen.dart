import 'package:flutter/material.dart';
import 'package:opop/features/auth/preference/auth_preference.dart';
import 'package:opop/features/profile/presentation/screens/friend_profile_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../profile/presentation/screens/user_profile_screen.dart';
import '../../data/models/chat_conversation.dart';
import '../widgets/chat_filter_chips.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/chat_search_bar.dart';
import '../widgets/mbti_pull_to_refresh.dart';
import 'chat_detail_screen.dart';
import 'new_chat_screen.dart';

/// Chat list screen for MBTI Explorer app
/// Displays all conversations with search and filtering capabilities
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatConversation> _conversations = [];
  List<ChatConversation> _filteredConversations = [];
  String _searchQuery = '';
  ConversationType? _selectedFilter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  //TODO: get userData
  void _showUserData() async {
    final authPreference = AuthPreference();
    authPreference.getLoginData();
  }

  void _loadConversations() {
    _isLoading = true;

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _conversations = _getDummyConversations();
        _applyFilters();
        _isLoading = false;
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onFilterChanged(ConversationType? type) {
    setState(() {
      _selectedFilter = type;
      _applyFilters();
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _conversations = _getDummyConversations();
      _applyFilters();
      _isLoading = false;
    });

    // Show success message with personality-themed feedback
    if (mounted) {
      final messages = [
        'Conversations refreshed! 🎉',
        'New insights loaded! 💡',
        'Chat data updated! 🔄',
        'Personality insights refreshed! 🧠',
        'Connections updated! 🌟',
      ];

      final randomMessage =
          messages[DateTime.now().millisecond % messages.length];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(randomMessage),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: AppColors.textInverse,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  void _onConversationTap(ChatConversation conversation) {
    // Mark conversation as read by setting unread count to 0
    if (conversation.unreadCount > 0) {
      final index = _conversations.indexWhere(
        (conv) => conv.id == conversation.id,
      );
      if (index != -1) {
        _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
        _applyFilters();
      }
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(conversation: conversation),
      ),
    );
  }

  void _applyFilters() {
    List<ChatConversation> filtered = _conversations;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((conv) {
        return conv.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            conv.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply type filter
    if (_selectedFilter != null) {
      filtered = filtered
          .where((conv) => conv.type == _selectedFilter)
          .toList();
    }

    setState(() {
      _filteredConversations = filtered;
    });
  }

  int _getTotalUnreadCount() {
    return _conversations.fold(0, (sum, conv) => sum + conv.unreadCount);
  }

  List<ChatConversation> _getDummyConversations() {
    return [
      ChatConversation(
        id: '1',
        title: 'Sarah Chen (ENFP)',
        lastMessage: 'Hey! How are you doing?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
        lastSenderName: 'Sarah Chen',
        lastSenderAvatar: '👩‍🦰',
        unreadCount: 2,
        participantIds: ['user_1', 'user_2'],
        type: ConversationType.personal,
        metadata: {'mbtiType': 'ENFP'},
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatConversation(
        id: '2',
        title: 'MBTI Discussion Group',
        lastMessage: 'Alex: I think INTJs are the most strategic',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
        lastSenderName: 'Alex Rivera',
        lastSenderAvatar: '👨‍💼',
        unreadCount: 0,
        participantIds: ['user_1', 'user_2', 'user_3'],
        type: ConversationType.group,
        metadata: {'topic': 'Personality Types'},
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ChatConversation(
        id: '3',
        title: 'Personality Assessment Support',
        lastMessage: 'Your assessment results are ready!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
        lastSenderName: 'MBTI Assistant',
        lastSenderAvatar: '🤖',
        unreadCount: 1,
        participantIds: ['user_1', 'support_bot'],
        type: ConversationType.support,
        metadata: {'assessmentId': 'mbti_full_2024'},
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      ChatConversation(
        id: '4',
        title: 'Maya Patel (INTJ)',
        lastMessage: 'The new project deadline has been moved to next week',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 15)),
        lastSenderName: 'Maya Patel',
        lastSenderAvatar: '👩‍🔬',
        unreadCount: 3,
        participantIds: ['user_1', 'user_4'],
        type: ConversationType.personal,
        metadata: {'mbtiType': 'INTJ'},
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      ChatConversation(
        id: '5',
        title: 'David Park (ESFJ)',
        lastMessage: 'Thanks for helping me with the presentation!',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        lastSenderName: 'David Park',
        lastSenderAvatar: '👨‍⚕️',
        unreadCount: 0,
        participantIds: ['user_1', 'user_5'],
        type: ConversationType.personal,
        metadata: {'mbtiType': 'ESFJ'},
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      ChatConversation(
        id: '6',
        title: 'Creative Thinkers Hub',
        lastMessage: 'Emma: Let\'s brainstorm some new ideas for the project',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        lastSenderName: 'Emma Wilson',
        lastSenderAvatar: '👩‍💻',
        unreadCount: 5,
        participantIds: ['user_1', 'user_6', 'user_7', 'user_8'],
        type: ConversationType.group,
        metadata: {'topic': 'Creative Projects'},
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatConversation(
        id: '7',
        title: 'Jordan Kim (ENTP)',
        lastMessage: 'Did you see the latest tech news?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 45)),
        lastSenderName: 'Jordan Kim',
        lastSenderAvatar: '👨‍🎓',
        unreadCount: 0,
        participantIds: ['user_1', 'user_9'],
        type: ConversationType.personal,
        metadata: {'mbtiType': 'ENTP'},
        createdAt: DateTime.now().subtract(const Duration(days: 35)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      ChatConversation(
        id: '8',
        title: 'Lisa Chang (INFP)',
        lastMessage: 'I found this amazing coffee shop we should visit',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 4)),
        lastSenderName: 'Lisa Chang',
        lastSenderAvatar: '👩‍🏫',
        unreadCount: 1,
        participantIds: ['user_1', 'user_10'],
        type: ConversationType.personal,
        metadata: {'mbtiType': 'INFP'},
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      ChatConversation(
        id: '9',
        title: 'Chris Thompson (ISFP)',
        lastMessage: 'The art exhibition was incredible!',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 6)),
        lastSenderName: 'Chris Thompson',
        lastSenderAvatar: '👨‍🎨',
        unreadCount: 0,
        participantIds: ['user_1', 'user_11'],
        type: ConversationType.personal,
        metadata: {'mbtiType': 'ISFP'},
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      ChatConversation(
        id: '10',
        title: 'Study Group - Psychology',
        lastMessage: 'Prof: Remember to submit your assignments by Friday',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 20)),
        lastSenderName: 'Professor Davis',
        lastSenderAvatar: '👨‍🏫',
        unreadCount: 2,
        participantIds: ['user_1', 'user_12', 'user_13', 'user_14', 'user_15'],
        type: ConversationType.group,
        metadata: {'topic': 'Psychology Studies'},
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 20)),
      ),
      ChatConversation(
        id: '11',
        title: 'Rachel Green (ESTP)',
        lastMessage: 'Wanna go hiking this weekend?',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 10)),
        lastSenderName: 'Rachel Green',
        lastSenderAvatar: '👩‍🦱',
        unreadCount: 1,
        participantIds: ['user_1', 'user_16'],
        type: ConversationType.personal,
        metadata: {'mbtiType': 'ESTP'},
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatConversation(
        id: '12',
        title: 'Tech Innovators',
        lastMessage: 'Mike: The new AI model just broke performance records!',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 25)),
        lastSenderName: 'Mike Johnson',
        lastSenderAvatar: '👨‍💻',
        unreadCount: 8,
        participantIds: ['user_1', 'user_17', 'user_18', 'user_19'],
        type: ConversationType.group,
        metadata: {'topic': 'Technology & Innovation'},
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
    ];
  }

  void _navigateToProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const UserProfileScreen()));
  }

  void _onAvatarTap() {
    // TODO: Navigate to user friend's profile
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FriendProfileScreen()),
    );
  }

  void _navigateToNewChat() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NewChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchAndFilters(),
            _buildConversationList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewChat,
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: Icon(
          Icons.add_comment,
          color: AppColors.textInverse,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _navigateToProfile,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: AppShadows.accent,
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Text(
                  '👤',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textInverse,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chats',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${_conversations.length} conversations',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildUnreadBadge(),
        ],
      ),
    );
  }

  Widget _buildUnreadBadge() {
    final unreadCount = _getTotalUnreadCount();
    if (unreadCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppSpacing.full),
        boxShadow: AppShadows.error,
      ),
      child: Text(
        unreadCount.toString(),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textInverse,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: AppShadows.soft,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: ChatSearchBar(
              onSearchChanged: _onSearchChanged,
              hintText: 'Search conversations...',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ChatFilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList() {
    Widget content;

    if (_isLoading) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Loading conversations...',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    } else if (_filteredConversations.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _searchQuery.isNotEmpty || _selectedFilter != null
                  ? 'No conversations found'
                  : 'No conversations yet',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _searchQuery.isNotEmpty || _selectedFilter != null
                  ? 'Try adjusting your search or filters'
                  : 'Start a conversation to get started!',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDisabled,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      content = ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: _filteredConversations.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final conversation = _filteredConversations[index];
          return Container(
            decoration: BoxDecoration(
              boxShadow: AppShadows.subtle,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: ChatListItem(
              conversation: conversation,
              onTap: () => _onConversationTap(conversation),
              onAvatarTap: () => _onAvatarTap(),
            ),
          );
        },
      );
    }

    return Expanded(
      child: MBTIPullToRefresh(
        onRefresh: _onRefresh,
        displacement: 80.0,
        child: content,
      ),
    );
  }
}
