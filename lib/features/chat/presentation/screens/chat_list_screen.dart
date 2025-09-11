import 'package:flutter/material.dart';
import 'package:opop/features/auth/preference/auth_preference.dart';
import 'package:opop/features/chat/presentation/data/chat_list_data.dart';
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
  final _chatList = ChatModel.getConversations;
  String _searchQuery = '';
  ConversationType? _selectedFilter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  //TODO: get userData
  void _showUserData(Future<String?> userId) async {
    final authPreference = AuthPreference();
    userId = authPreference.getLoginData();
    authPreference.getLoginData();
    Text(userId.toString());
  }

  void _loadConversations() {
    _isLoading = true;

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _conversations = _chatList;
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
      _conversations = _chatList;
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
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const NewChatScreen()));
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
        child: Icon(Icons.add_comment, color: AppColors.textInverse, size: 24),
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
