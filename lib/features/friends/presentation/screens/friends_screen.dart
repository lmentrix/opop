import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../chat/data/models/chat_conversation.dart';
import '../../../chat/presentation/screens/chat_detail_screen.dart';
import '../../../discovery/presentation/screens/explore_map_screen.dart';

/// Friends screen for managing MBTI connections
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [_buildSliverAppBar(), _buildFriendsContent(context)],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Friends',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'Connect with MBTI enthusiasts',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textInverse.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsContent(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('My Friends'),
            const SizedBox(height: AppSpacing.md),
            _buildFriendsList(context),
            const SizedBox(height: AppSpacing.xl),
            _buildSectionTitle('Suggested Connections'),
            const SizedBox(height: AppSpacing.md),
            _buildSuggestedConnections(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.titleLarge.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    final friends = [
      {'name': 'Sarah Chen', 'mbti': 'ENFP', 'avatar': '👩‍💻'},
      {'name': 'Mike Johnson', 'mbti': 'ISTJ', 'avatar': '👨‍💼'},
      {'name': 'Emma Davis', 'mbti': 'INFJ', 'avatar': '👩‍🎨'},
    ];

    return Column(
      children: friends.map((friend) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.full),
                ),
                child: Center(
                  child: Text(
                    friend['avatar'] as String,
                    style: AppTypography.titleLarge.copyWith(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend['name'] as String,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      friend['mbti'] as String,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _onChatTap(context, friend),
                icon: Icon(
                  Icons.message,
                  color: AppColors.primary,
                  size: AppSpacing.iconSize,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _onChatTap(BuildContext context, Map<String, dynamic> friend) {
    // Create or navigate to chat with the friend
    final conversation = ChatConversation(
      id: 'chat_${friend['name']}_${DateTime.now().millisecondsSinceEpoch}',
      title: friend['name'] as String,
      lastMessage: 'Start a conversation with ${friend['name']}',
      lastMessageTime: DateTime.now(),
      lastSenderName: friend['name'] as String,
      lastSenderAvatar: friend['avatar'] as String,
      unreadCount: 0,
      participantIds: ['user', 'friend_${friend['name']}'],
      type: ConversationType.personal,
      metadata: {
        'friendName': friend['name'],
        'friendMBTI': friend['mbti'],
        'friendAvatar': friend['avatar'],
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(conversation: conversation),
      ),
    );
  }

  Widget _buildSuggestedConnections(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, size: 48, color: AppColors.primary),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Find new connections',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Discover people with similar MBTI types and interests',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExploreMapScreen(),
                ),
              );
            },
            child: Text(
              'Explore',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
