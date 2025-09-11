import 'package:flutter/material.dart';
import 'package:opop/features/chat/presentation/data/chat_friend_data.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../profile/data/models/friend_profile.dart';
import '../../data/models/chat_conversation.dart';
import 'chat_detail_screen.dart';

/// New chat screen for selecting a contact to start a conversation
class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<FriendProfile> _allFriends = [];
  List<FriendProfile> _filteredFriends = [];
  final _dummyFriend = ChatFriendClass.friends;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFriends();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadFriends() {
    // Simulate loading friends data
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _allFriends = _dummyFriend;
          _filteredFriends = _allFriends;
          _isLoading = false;
        });
      }
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFriends = _allFriends.where((friend) {
        return friend.name.toLowerCase().contains(query) ||
            friend.mbtiType.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _startNewChat(FriendProfile friend) {
    // Create a new conversation and navigate to chat detail
    final newConversation = _createNewConversation(friend);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(conversation: newConversation),
      ),
    );
  }

  ChatConversation _createNewConversation(FriendProfile friend) {
    return ChatConversation(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      title: '${friend.name} (${friend.mbtiType})',
      lastMessage: 'Start a conversation...',
      lastMessageTime: DateTime.now(),
      lastSenderName: friend.name,
      lastSenderAvatar: friend.avatar,
      unreadCount: 0,
      participantIds: ['user', friend.id],
      type: ConversationType.personal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Chat',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: AppSpacing.md),
          _buildFriendsList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search friends...',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surfaceVariant.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
        style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildFriendsList() {
    if (_isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Loading friends...',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredFriends.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_search,
                size: 64,
                color: AppColors.textDisabled,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No friends found',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Try adjusting your search',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textDisabled,
                ),
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
        itemCount: _filteredFriends.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final friend = _filteredFriends[index];
          return _buildFriendTile(friend);
        },
      ),
    );
  }

  Widget _buildFriendTile(FriendProfile friend) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _getMBTIGradient(friend.mbtiType),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Text(
              friend.avatar,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textInverse,
              ),
            ),
          ),
        ),
        title: Text(
          friend.name,
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              friend.mbtiType,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getStatusColor(friend.status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  friend.status ?? 'Offline',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (friend.conversationCount > 0) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '• ${friend.conversationCount} chats',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.chat_bubble_outline, color: AppColors.primary),
        onTap: () => _startNewChat(friend),
      ),
    );
  }

  List<Color> _getMBTIGradient(String mbtiType) {
    switch (mbtiType.substring(0, 2)) {
      case 'EN':
        return [AppColors.diplomat, AppColors.diplomat.withOpacity(0.7)];
      case 'ES':
        return [AppColors.explorer, AppColors.explorer.withOpacity(0.7)];
      case 'IN':
        return [AppColors.analyst, AppColors.analyst.withOpacity(0.7)];
      case 'IS':
        return [AppColors.sentinel, AppColors.sentinel.withOpacity(0.7)];
      default:
        return [AppColors.primary, AppColors.primary.withOpacity(0.7)];
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'away':
        return AppColors.warning;
      case 'offline':
        return AppColors.textDisabled;
      default:
        return AppColors.textDisabled;
    }
  }
}
