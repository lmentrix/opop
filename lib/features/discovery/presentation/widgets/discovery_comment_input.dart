import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';

/// Comment input widget for writing new comments - Instagram/TikTok style
class DiscoveryCommentInput extends StatefulWidget {
  final VoidCallback? onSend;
  final String? hintText;
  final TextEditingController? controller;

  const DiscoveryCommentInput({
    super.key,
    this.onSend,
    this.hintText,
    this.controller,
  });

  @override
  State<DiscoveryCommentInput> createState() => _DiscoveryCommentInputState();
}

class _DiscoveryCommentInputState extends State<DiscoveryCommentInput> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSend() {
    if (_hasText && widget.onSend != null) {
      widget.onSend!();
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.md),
          topRight: Radius.circular(AppSpacing.md),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppSpacing.full),
              ),
            ),
          ),
          
          // Title
          Row(
            children: [
              Text(
                'Comments',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceVariant.withOpacity(0.3),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(32, 32),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // Input field with actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Avatar
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '👤',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              
              // Input field
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                    border: Border.all(
                      color: AppColors.textSecondary.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          maxLines: 3,
                          minLines: 1,
                          style: AppTypography.bodyMedium.copyWith(
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText ?? 'Add a comment...',
                            hintStyle: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                          ),
                        ),
                      ),
                      
                      // Action buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Emoji button
                          IconButton(
                            onPressed: () {
                              // TODO: Implement emoji picker
                            },
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(32, 32),
                            ),
                          ),
                          
                          // MBTI selector
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              // Handle MBTI selection
                            },
                            itemBuilder: (context) => [
                              'Analyst 🔍',
                              'Diplomat 🤝',
                              'Sentinel 🛡️',
                              'Explorer 🚀',
                            ].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 4,
                              ),
                              child: Icon(
                                Icons.psychology,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: AppSpacing.xs),
                          
                          // Send button
                          Container(
                            decoration: BoxDecoration(
                              color: _hasText ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: _hasText ? _handleSend : null,
                              icon: Icon(
                                Icons.send,
                                size: 16,
                                color: _hasText ? AppColors.textInverse : AppColors.textSecondary,
                              ),
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(32, 32),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.sm),
          
          // Quick actions row
          Row(
            children: [
              // Quick phrases
              Wrap(
                spacing: AppSpacing.xs,
                children: [
                  _buildQuickPhrase('❤️'),
                  _buildQuickPhrase('🔥'),
                  _buildQuickPhrase('👏'),
                  _buildQuickPhrase('😂'),
                  _buildQuickPhrase('🎉'),
                ],
              ),
              
              const Spacer(),
              
              // Character counter
              Text(
                '${_controller.text.length}/500',
                style: AppTypography.bodySmall.copyWith(
                  color: _controller.text.length > 450 
                      ? AppColors.error 
                      : AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPhrase(String emoji) {
    return GestureDetector(
      onTap: () {
        _controller.text += emoji;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppSpacing.full),
        ),
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}