import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/models/chat_message.dart';

/// Chat message bubble widget for displaying individual messages
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;
  final bool showAvatar;
  final bool showTime;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.showAvatar = false,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser && showAvatar) _buildAvatar(),
          if (!isUser && showAvatar) const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser && showAvatar) _buildSenderName(),
                if (!isUser && showAvatar)
                  const SizedBox(height: AppSpacing.xs),
                _buildMessageBubble(context),
                if (showTime) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _buildTimestamp(),
                ],
              ],
            ),
          ),
          if (isUser && showAvatar) const SizedBox(width: AppSpacing.sm),
          if (isUser && showAvatar) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: _getAvatarColor(),
      child: Text(
        message.senderAvatar,
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textInverse,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSenderName() {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.sm),
      child: Text(
        message.senderName,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : AppColors.surfaceVariant,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.md),
          topRight: Radius.circular(AppSpacing.md),
          bottomLeft: Radius.circular(isUser ? AppSpacing.md : AppSpacing.xs),
          bottomRight: Radius.circular(isUser ? AppSpacing.xs : AppSpacing.md),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _buildMessageContent(),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: AppTypography.bodyMedium.copyWith(
            color: isUser ? AppColors.textInverse : AppColors.textPrimary,
            height: 1.4,
          ),
        );

      case MessageType.personalityResult:
        return _buildPersonalityResultContent();

      case MessageType.assessmentQuestion:
        return _buildAssessmentQuestionContent();

      case MessageType.image:
        return _buildImageContent();

      case MessageType.system:
        return _buildSystemContent();

      default:
        return Text(
          message.content,
          style: AppTypography.bodyMedium.copyWith(
            color: isUser ? AppColors.textInverse : AppColors.textPrimary,
            height: 1.4,
          ),
        );
    }
  }

  Widget _buildPersonalityResultContent() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppColors.primary,
                size: AppSpacing.iconSize,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Personality Result',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message.content,
            style: AppTypography.bodyMedium.copyWith(
              color: isUser ? AppColors.textInverse : AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentQuestionContent() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.analyst.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.analyst.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.quiz,
                color: AppColors.analyst,
                size: AppSpacing.iconSize,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Assessment Question',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.analyst,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message.content,
            style: AppTypography.bodyMedium.copyWith(
              color: isUser ? AppColors.textInverse : AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    // For image messages, the content is the full image path
    String imagePath = message.content;
    String? fileName = message.metadata?['fileName'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(color: AppColors.outline.withOpacity(0.3)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: imagePath.isNotEmpty
                ? _buildActualImage(imagePath)
                : _buildImagePlaceholder(),
          ),
        ),
        if (fileName != null && fileName.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            fileName,
            style: AppTypography.bodySmall.copyWith(
              color: isUser ? AppColors.textInverse : AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActualImage(String imagePath) {
    return GestureDetector(
      onTap: () => _showFullScreenImage(imagePath),
      child: File(imagePath).existsSync()
          ? Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImageError();
              },
            )
          : _buildImageError(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 200,
      height: 150,
      color: AppColors.surfaceVariant,
      child: const Center(
        child: Icon(Icons.image, size: 48, color: AppColors.textDisabled),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      width: 200,
      height: 150,
      color: AppColors.error.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48, color: AppColors.error),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Failed to load image',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  String? _extractImagePath(String content) {
    // Extract image path from content like "[Image: filename.jpg]"
    final regex = RegExp(r'\[Image:\s*(.*?)\]');
    final match = regex.firstMatch(content);
    return match?.group(1);
  }

  String? _extractImageCaption(String content) {
    // Extract any text that's not the image path
    final regex = RegExp(r'\[Image:\s*.*?\](.*)');
    final match = regex.firstMatch(content);
    return match?.group(1)?.trim();
  }

  void _showFullScreenImage(String imagePath) {
    // For now, this is a placeholder
    // In a real app, you'd show a full-screen image viewer dialog
    print('Show full screen image: ${imagePath.split('/').last}');
  }

  Widget _buildSystemContent() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, color: AppColors.textSecondary, size: 16),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              message.content,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp() {
    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 0 : AppSpacing.sm,
        right: isUser ? AppSpacing.sm : 0,
      ),
      child: Text(
        _formatTime(message.timestamp),
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _getAvatarColor() {
    if (isUser) return AppColors.primary;

    // You can customize this based on sender or message type
    return AppColors.secondary;
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      return '${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
    } else {
      return 'now';
    }
  }
}
