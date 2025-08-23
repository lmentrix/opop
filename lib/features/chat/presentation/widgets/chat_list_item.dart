import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/models/chat_conversation.dart';

/// Chat list item widget for displaying individual conversations
class ChatListItem extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildContent()),
              _buildTrailingInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getAvatarColor(),
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          child: Center(
            child: Text(
              conversation.lastSenderAvatar,
              style: AppTypography.titleLarge.copyWith(fontSize: 24),
            ),
          ),
        ),
        if (conversation.unreadCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(AppSpacing.full),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                conversation.unreadCount > 99
                    ? '99+'
                    : conversation.unreadCount.toString(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                conversation.title,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildTypeIndicator(),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          conversation.lastMessage,
          style: AppTypography.bodyMedium.copyWith(
            color:
                conversation.unreadCount > 0
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
            fontWeight:
                conversation.unreadCount > 0
                    ? FontWeight.w500
                    : FontWeight.w400,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTrailingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatTime(conversation.lastMessageTime),
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (conversation.unreadCount > 0)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.full),
            ),
          ),
      ],
    );
  }

  Widget _buildTypeIndicator() {
    Color indicatorColor;
    String indicatorText;

    switch (conversation.type) {
      case ConversationType.assessment:
        indicatorColor = AppColors.analyst;
        indicatorText = 'A';
        break;
      case ConversationType.personality:
        indicatorColor = AppColors.diplomat;
        indicatorText = 'P';
        break;
      case ConversationType.support:
        indicatorColor = AppColors.sentinel;
        indicatorText = 'S';
        break;
      case ConversationType.group:
        indicatorColor = AppColors.explorer;
        indicatorText = 'G';
        break;
      case ConversationType.system:
        indicatorColor = AppColors.primary;
        indicatorText = 'S';
        break;
      default:
        indicatorColor = AppColors.textSecondary;
        indicatorText = 'P';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
        border: Border.all(color: indicatorColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        indicatorText,
        style: AppTypography.labelSmall.copyWith(
          color: indicatorColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getAvatarColor() {
    switch (conversation.type) {
      case ConversationType.assessment:
        return AppColors.analyst;
      case ConversationType.personality:
        return AppColors.diplomat;
      case ConversationType.support:
        return AppColors.sentinel;
      case ConversationType.group:
        return AppColors.explorer;
      case ConversationType.system:
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
