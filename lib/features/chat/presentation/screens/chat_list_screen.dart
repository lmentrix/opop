import 'package:flutter/material.dart';
import 'package:opop/features/auth/preference/auth_preference.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../profile/presentation/screens/user_profile_screen.dart';
import '../../data/datasources/chat_dummy_data.dart';
import '../../data/models/chat_conversation.dart';
import '../widgets/chat_filter_chips.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/chat_search_bar.dart';
import 'chat_detail_screen.dart';

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
    setState(() {
      _isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _conversations = ChatDummyData.getConversations();
          _filteredConversations = _conversations;
          _isLoading = false;
        });
      }
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

  void _applyFilters() {
    List<ChatConversation> filtered = _conversations;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = ChatDummyData.searchConversations(_searchQuery);
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

  void _onConversationTap(ChatConversation conversation) {
    // Mark conversation as read by setting unread count to 0
    if (conversation.unreadCount > 0) {
      _markConversationAsRead(conversation);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(conversation: conversation),
      ),
    );
  }

  void _markConversationAsRead(ChatConversation conversation) {
    setState(() {
      // Update the conversation in the original list
      final index = _conversations.indexWhere(
        (conv) => conv.id == conversation.id,
      );
      if (index != -1) {
        _conversations[index] = conversation.copyWith(unreadCount: 0);
      }

      // Update the filtered list as well
      final filteredIndex = _filteredConversations.indexWhere(
        (conv) => conv.id == conversation.id,
      );
      if (filteredIndex != -1) {
        _filteredConversations[filteredIndex] = conversation.copyWith(
          unreadCount: 0,
        );
      }
    });
  }

  void _onNewChat() {
    // TODO: Navigate to new chat screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Starting new chat...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const UserProfileScreen()));
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
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _navigateToProfile,
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
    final unreadCount = ChatDummyData.getUnreadCount();
    if (unreadCount == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppSpacing.full),
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
      child: Column(
        children: [
          ChatSearchBar(
            onSearchChanged: _onSearchChanged,
            hintText: 'Search conversations...',
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
    if (_isLoading) {
      return Expanded(
        child: Center(
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
        ),
      );
    }

    if (_filteredConversations.isEmpty) {
      return Expanded(
        child: Center(
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
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: _filteredConversations.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final conversation = _filteredConversations[index];
          return ChatListItem(
            conversation: conversation,
            onTap: () => _onConversationTap(conversation),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _onNewChat,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textInverse,
      child: const Icon(Icons.chat),
    );
  }
}
