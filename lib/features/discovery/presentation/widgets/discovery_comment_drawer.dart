import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';

import 'discovery_comment_input.dart';
import 'discovery_comment_item.dart';

/// Comment drawer widget for discovery page
class DiscoveryCommentDrawer extends StatefulWidget {
  final String? contentTitle;
  final List<Map<String, dynamic>>? initialComments;
  final Function(Map<String, dynamic>)? onCommentAdded;
  final Function(Map<String, dynamic>)? onCommentLiked;

  const DiscoveryCommentDrawer({
    super.key,
    this.contentTitle,
    this.initialComments,
    this.onCommentAdded,
    this.onCommentLiked,
  });

  @override
  State<DiscoveryCommentDrawer> createState() => _DiscoveryCommentDrawerState();
}

class _DiscoveryCommentDrawerState extends State<DiscoveryCommentDrawer> {
  late List<Map<String, dynamic>> _comments;
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _comments = widget.initialComments ?? _createDummyComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _createDummyComments() {
    return [
      {
        'id': '1',
        'userName': 'Sarah Chen',
        'mbtiType': 'ENFP',
        'avatar': '🦋',
        'content':
            'This is so insightful! I\'ve been thinking about how MBTI types approach problem-solving differently. As an ENFP, I definitely see patterns in how I brainstorm versus my INTJ friends.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
        'likes': 24,
        'isLiked': false,
        'isPinned': true,
        'replies': [
          {
            'userName': 'Alex Kumar',
            'content':
                'Totally agree! The way different types process information is fascinating.',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
          },
          {
            'userName': 'Maya Patel',
            'content': 'Same here! ENFPs are such great brainstormers',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 8)),
          },
        ],
      },
      {
        'id': '2',
        'userName': 'Marcus Johnson',
        'mbtiType': 'INTJ',
        'avatar': '🧠',
        'content':
            'From a strategic perspective, the analysis here is quite thorough. However, I\'d like to see more data-driven insights about the correlation between cognitive functions and decision-making patterns.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'likes': 18,
        'isLiked': true,
        'replies': [
          {
            'userName': 'Dr. Lisa Wong',
            'content':
                'Excellent point, Marcus. We\'re currently working on a study about this exact correlation.',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
          },
        ],
      },
      {
        'id': '3',
        'userName': 'Elena Rodriguez',
        'mbtiType': 'INFJ',
        'avatar': '🌟',
        'content':
            'This really resonates with me on a deep level. The way it describes the intuitive process feels so accurate. I often find myself understanding patterns before I can explain them logically.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'likes': 31,
        'isLiked': false,
        'replies': [],
      },
      {
        'id': '4',
        'userName': 'David Kim',
        'mbtiType': 'ENTP',
        'avatar': '⚡',
        'content':
            'Interesting perspective! I love debating these ideas. Has anyone considered how the enneagram types might interact with MBTI? That could add another layer to this analysis.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        'likes': 12,
        'isLiked': false,
        'replies': [
          {
            'userName': 'Sophie Turner',
            'content':
                'Great question! I\'m a 7w8 ENTP and the combination definitely explains a lot about my personality.',
            'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          },
          {
            'userName': 'James Wilson',
            'content':
                'This would be amazing to explore! The intersection of typology systems is fascinating.',
            'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          },
        ],
      },
      {
        'id': '5',
        'userName': 'Rachel Green',
        'mbtiType': 'ISFJ',
        'avatar': '🌸',
        'content':
            'As someone who works in healthcare, I find this incredibly helpful for understanding patient communication styles. It\'s amazing how much better my interactions have become since learning about MBTI.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'likes': 27,
        'isLiked': false,
        'replies': [],
      },
    ];
  }

  void _handleAddComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final newComment = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'userName': 'You',
          'mbtiType': 'ENFP', // Could be dynamic
          'avatar': '👤',
          'content': _commentController.text,
          'timestamp': DateTime.now(),
          'likes': 0,
          'isLiked': false,
          'isPinned': false,
          'replies': [],
        };

        setState(() {
          _comments.insert(0, newComment); // Add to top
          _isLoading = false;
        });

        // Clear input
        _commentController.clear();

        // Notify parent
        widget.onCommentAdded?.call(newComment);

        // Scroll to top to show new comment
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleLikeComment(Map<String, dynamic> comment) {
    setState(() {
      final index = _comments.indexWhere((c) => c['id'] == comment['id']);
      if (index != -1) {
        _comments[index]['isLiked'] = !(_comments[index]['isLiked'] ?? false);
        _comments[index]['likes'] =
            (_comments[index]['likes'] ?? 0) +
            (_comments[index]['isLiked'] ? 1 : -1);
      }
    });

    widget.onCommentLiked?.call(comment);
  }

  void _handleReplyComment(Map<String, dynamic> comment) {
    // Show reply dialog or navigate to reply screen
    _showReplyDialog(comment);
  }

  void _showReplyDialog(Map<String, dynamic> comment) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reply to ${comment['userName']}'),
        content: TextField(
          controller: replyController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write your reply...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                setState(() {
                  final index = _comments.indexWhere(
                    (c) => c['id'] == comment['id'],
                  );
                  if (index != -1) {
                    final newReply = {
                      'userName': 'You',
                      'content': replyController.text,
                      'timestamp': DateTime.now(),
                    };
                    _comments[index]['replies'] ??= [];
                    _comments[index]['replies'].add(newReply);
                  }
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Reply'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.md),
          topRight: Radius.circular(AppSpacing.md),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
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
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
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
                
                // Title and stats
                Row(
                  children: [
                    Text(
                      widget.contentTitle ?? 'Comments',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_comments.length}',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
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
              ],
            ),
          ),

          // Comments list
          Expanded(
            child: _isLoading && _comments.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 48,
                          color: AppColors.textDisabled,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'No comments yet',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Be the first to comment',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return DiscoveryCommentItem(
                        comment: comment,
                        onLike: () => _handleLikeComment(comment),
                        onReply: () => _handleReplyComment(comment),
                      );
                    },
                  ),
          ),

          // Comment input
          DiscoveryCommentInput(
            controller: _commentController,
            hintText: 'Add a comment...',
            onSend: _handleAddComment,
          ),
        ],
      ),
    );
  }
}
