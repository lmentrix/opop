import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';

/// Individual comment item widget for discovery page - Instagram/TikTok style
class DiscoveryCommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;

  const DiscoveryCommentItem({
    super.key,
    required this.comment,
    this.onLike,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main comment row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getMBTIColors(comment['mbtiType'] ?? 'ENFP'),
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    comment['avatar'] ?? '👤',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              
              // Comment content and actions
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info and comment
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Username and MBTI type
                          Row(
                            children: [
                              Text(
                                comment['userName'] ?? 'Anonymous',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (comment['mbtiType'] != null) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  '• ${comment['mbtiType']}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              if (comment['isPinned'] == true) ...[
                                const SizedBox(width: AppSpacing.xs),
                                Icon(
                                  Icons.push_pin,
                                  size: 12,
                                  color: AppColors.warning,
                                ),
                              ],
                            ],
                          ),
                          
                          const SizedBox(height: 2),
                          
                          // Comment content
                          Text(
                            comment['content'] ?? '',
                            style: AppTypography.bodyMedium.copyWith(
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppSpacing.xs),
                    
                    // Actions row
                    Row(
                      children: [
                        // Timestamp
                        Text(
                          _formatTimestamp(comment['timestamp']),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        
                        // Like button
                        GestureDetector(
                          onTap: onLike,
                          child: Row(
                            children: [
                              Icon(
                                comment['isLiked'] == true ? Icons.favorite : Icons.favorite_border,
                                size: 14,
                                color: comment['isLiked'] == true ? AppColors.error : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${comment['likes'] ?? 0}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: comment['isLiked'] == true ? AppColors.error : AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: AppSpacing.md),
                        
                        // Reply button
                        GestureDetector(
                          onTap: onReply,
                          child: Text(
                            'Reply',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // More options
                        Icon(
                          Icons.more_horiz,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    
                    // Replies section
                    if (comment['replies'] != null && comment['replies'].isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // View replies button
                          GestureDetector(
                            onTap: onReply,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppSpacing.xs),
                              ),
                              child: Text(
                                'View ${comment['replies'].length} ${comment['replies'].length == 1 ? 'reply' : 'replies'}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: AppSpacing.xs),
                          
                          // Show first 2 replies
                          ...comment['replies'].take(2).map<Widget>((reply) => 
                            Padding(
                              padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.xs),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.only(right: AppSpacing.xs),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '👤',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.xs,
                                        vertical: AppSpacing.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(AppSpacing.xs),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reply['userName'] ?? 'Anonymous',
                                            style: AppTypography.bodySmall.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            reply['content'] ?? '',
                                            style: AppTypography.bodySmall.copyWith(
                                              fontSize: 12,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).toList(),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getMBTIColors(String mbtiType) {
    switch (mbtiType) {
      case 'ENFP':
      case 'INFP':
      case 'ENFJ':
      case 'INFJ':
        return [AppColors.diplomat, AppColors.diplomat.withOpacity(0.7)];
      case 'INTJ':
      case 'INTP':
      case 'ENTJ':
      case 'ENTP':
        return [AppColors.analyst, AppColors.analyst.withOpacity(0.7)];
      case 'ISTJ':
      case 'ISFJ':
      case 'ESTJ':
      case 'ESFJ':
        return [AppColors.sentinel, AppColors.sentinel.withOpacity(0.7)];
      case 'ISTP':
      case 'ISFP':
      case 'ESTP':
      case 'ESFP':
        return [AppColors.explorer, AppColors.explorer.withOpacity(0.7)];
      default:
        return [AppColors.primary, AppColors.primary.withOpacity(0.7)];
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is DateTime) {
      final now = DateTime.now();
      final difference = now.difference(timestamp);
      
      if (difference.inMinutes < 1) return 'Just now';
      if (difference.inHours < 1) return '${difference.inMinutes}m';
      if (difference.inDays < 1) return '${difference.inHours}h';
      if (difference.inDays < 7) return '${difference.inDays}d';
      
      return '${difference.inDays ~/ 7}w';
    }
    return 'now';
  }
}