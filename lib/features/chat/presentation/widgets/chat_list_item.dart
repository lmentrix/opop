import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/models/chat_conversation.dart';

/// Chat list item widget for displaying individual conversations
class ChatListItem extends StatefulWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final VoidCallback? onAvatarTap;
  final DismissDirectionCallback? onDismissed;
  final ConfirmDismissCallback? confirmDismissCallback;
  final DismissDirection? direction;

  const ChatListItem({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onAvatarTap,
    this.onDismissed,
    this.confirmDismissCallback,
    this.direction,
  });

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shadowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  bool _isPressed = false;
  bool _hasExecutedTap = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _shadowAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _shadowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shadowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
      _hasExecutedTap = false; // Reset the flag
    });
    _scaleController.forward();
    _shadowController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _resetAnimation(shouldExecuteOnTap: true);
  }

  void _handleTapCancel() {
    _resetAnimation(shouldExecuteOnTap: false);
  }

  void _resetAnimation({required bool shouldExecuteOnTap}) {
    setState(() {
      _isPressed = false;
    });
    _scaleController.reverse();
    _shadowController.reverse();

    // Only execute onTap if the gesture completed successfully and hasn't been executed yet
    if (shouldExecuteOnTap && !_hasExecutedTap) {
      _hasExecutedTap = true;
      // Immediate execution for better responsiveness
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _shadowAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.md),
              boxShadow: _isPressed
                  ? AppShadows.inner
                  : AppShadows.subtle
                        .map(
                          (shadow) => shadow.copyWith(
                            blurRadius:
                                shadow.blurRadius * _shadowAnimation.value,
                            spreadRadius:
                                shadow.spreadRadius * _shadowAnimation.value,
                          ),
                        )
                        .toList(),
            ),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              child: Material(
                color: _isPressed
                    ? AppColors.pressed
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSpacing.md),
                child: InkWell(
                  onTap: () {
                    // Only execute if not already executed through gesture
                    if (!_hasExecutedTap) {
                      _hasExecutedTap = true;
                      widget.onTap();
                    }
                  },
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  splashColor: AppColors.primary.withOpacity(0.1),
                  highlightColor: AppColors.primary.withOpacity(0.05),
                  child: GestureDetector(
                    onTapDown: _handleTapDown,
                    onTapUp: _handleTapUp,
                    onTapCancel: _handleTapCancel,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          if (widget.onDismissed != null) {
                            widget.onDismissed!(
                              direction,
                            ); // Ensure callback exists
                          }
                        },
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
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onAvatarTap,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            splashColor: Colors.white.withOpacity(0.3),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getAvatarColor(),
                borderRadius: BorderRadius.circular(AppSpacing.md),
                border: widget.onAvatarTap != null
                    ? Border.all(color: Colors.white.withOpacity(0.5), width: 1)
                    : null,
                boxShadow: AppShadows.medium,
              ),
              child: Center(
                child: Text(
                  widget.conversation.lastSenderAvatar,
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 28,
                    color: AppColors.textInverse,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.conversation.unreadCount > 0)
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
                boxShadow: AppShadows.error,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                widget.conversation.unreadCount > 99
                    ? '99+'
                    : widget.conversation.unreadCount.toString(),
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
                widget.conversation.title,
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
          widget.conversation.lastMessage,
          style: AppTypography.bodyMedium.copyWith(
            color: widget.conversation.unreadCount > 0
                ? AppColors.textPrimary
                : AppColors.textSecondary,
            fontWeight: widget.conversation.unreadCount > 0
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
          _formatTime(widget.conversation.lastMessageTime),
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (widget.conversation.unreadCount > 0)
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

    switch (widget.conversation.type) {
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
    switch (widget.conversation.type) {
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
