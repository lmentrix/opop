import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Trending topic detail screen for MBTI Explorer app
/// Shows detailed information about a specific trending MBTI topic
class TrendingTopicDetailScreen extends StatefulWidget {
  final Map<String, dynamic> topic;

  const TrendingTopicDetailScreen({
    super.key,
    required this.topic,
  });

  @override
  State<TrendingTopicDetailScreen> createState() => _TrendingTopicDetailScreenState();
}

class _TrendingTopicDetailScreenState extends State<TrendingTopicDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isBookmarked = false;
  bool _isLiked = false;
  int _viewCount = 1247;
  int _likeCount = 342;
  int _commentCount = 89;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _incrementViewCount();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _incrementViewCount() {
    // Simulate incrementing view count
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _viewCount++;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildTopicContent(),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildSliverAppBar() {
    final topicColor = widget.topic['color'] as Color;

    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: topicColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                topicColor,
                topicColor.withOpacity(0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                _buildTopicHeader(),
                const SizedBox(height: AppSpacing.lg),
                _buildTopicStats(),
              ],
            ),
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.textInverse,
          size: AppSpacing.iconSize,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _toggleBookmark,
          icon: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
        IconButton(
          onPressed: _showShareOptions,
          icon: Icon(
            Icons.share,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
      ],
    );
  }

  Widget _buildTopicHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.textInverse.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            widget.topic['icon'] as String,
            style: AppTypography.displayLarge.copyWith(
              fontSize: 64,
              color: AppColors.textInverse,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          widget.topic['title'] as String,
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTopicStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(Icons.visibility, _viewCount.toString(), 'Views'),
          _buildStatItem(Icons.favorite, _likeCount.toString(), 'Likes'),
          _buildStatItem(Icons.comment, _commentCount.toString(), 'Comments'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.textInverse,
          size: 20,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textInverse.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildTopicContent() {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverview(),
                const SizedBox(height: AppSpacing.xl),
                _buildKeyInsights(),
                const SizedBox(height: AppSpacing.xl),
                _buildPersonalityAnalysis(),
                const SizedBox(height: AppSpacing.xl),
                _buildRelatedTopics(),
                const SizedBox(height: AppSpacing.xl),
                _buildDiscussion(),
                const SizedBox(height: AppSpacing.xl * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: (widget.topic['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: widget.topic['color'] as Color,
                  size: AppSpacing.iconSize,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Topic Overview',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _getTopicOverview(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Insights',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ..._getInsights().map((insight) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(
              color: (widget.topic['color'] as Color).withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: widget.topic['color'] as Color,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  insight,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildPersonalityAnalysis() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (widget.topic['color'] as Color).withOpacity(0.1),
            (widget.topic['color'] as Color).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(
          color: (widget.topic['color'] as Color).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: widget.topic['color'] as Color,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Icon(
                  Icons.psychology,
                  color: AppColors.textInverse,
                  size: AppSpacing.iconSize,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Personality Analysis',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _getPersonalityAnalysis(),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedTopics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Topics',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _getRelatedTopics().map((topic) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: topic['color'] as Color,
              borderRadius: BorderRadius.circular(AppSpacing.full),
            ),
            child: Text(
              topic['title'] as String,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildDiscussion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community Discussion',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildCommentItem(
                'Sarah Chen',
                '👩‍🦰',
                'This topic really resonates with me! As an ENFP, I find these insights incredibly accurate.',
                2,
              ),
              const Divider(height: AppSpacing.lg),
              _buildCommentItem(
                'Alex Rodriguez',
                '👨‍💼',
                'Great analysis! I\'ve noticed similar patterns in my INTJ relationships.',
                1,
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: _joinDiscussion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.topic['color'] as Color,
                  foregroundColor: AppColors.textInverse,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                ),
                child: Text(
                  'Join Discussion',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(
    String name,
    String avatar,
    String comment,
    int hoursAgo,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: (widget.topic['color'] as Color).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            avatar,
            style: AppTypography.titleMedium,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${hoursAgo}h ago',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                comment,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _toggleLike,
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                ),
                label: Text(_isLiked ? 'Liked' : 'Like'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLiked ? AppColors.error : AppColors.surfaceVariant,
                  foregroundColor: _isLiked ? AppColors.textInverse : AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _joinDiscussion,
                icon: const Icon(Icons.comment),
                label: const Text('Comment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.topic['color'] as Color,
                  foregroundColor: AppColors.textInverse,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTopicOverview() {
    final title = widget.topic['title'] as String;
    switch (title) {
      case 'INTJ vs INTJ':
        return 'Explore the fascinating dynamics when two Architects meet. Discover how shared traits create both harmony and challenges in relationships, friendships, and professional collaborations.';
      case 'ENFP Relationships':
        return 'Dive into the world of Campaigner relationships. Learn how ENFPs bring enthusiasm, creativity, and deep emotional connections to their partnerships.';
      case 'ISTJ at Work':
        return 'Understanding the Logistician in professional environments. Discover how ISTJs contribute to organizational success through reliability, attention to detail, and structured thinking.';
      case 'ESFP Adventures':
        return 'Join the Entertainer on their journey through life\'s adventures. Explore how ESFPs bring joy, spontaneity, and excitement to every experience.';
      default:
        return 'Explore this fascinating MBTI topic and gain insights into personality dynamics, relationships, and personal growth.';
    }
  }

  List<String> _getInsights() {
    final title = widget.topic['title'] as String;
    switch (title) {
      case 'INTJ vs INTJ':
        return [
          'Shared strategic thinking creates powerful collaborations',
          'Mutual respect for independence and competence',
          'Potential communication challenges due to reserved nature',
          'Strong intellectual connection and shared vision',
        ];
      case 'ENFP Relationships':
        return [
          'Bring warmth and enthusiasm to relationships',
          'Value deep emotional connections',
          'Seek partners who appreciate their creativity',
          'Need partners who provide stability and grounding',
        ];
      case 'ISTJ at Work':
        return [
          'Excel in roles requiring attention to detail',
          'Value structure and clear procedures',
          'Reliable and consistent team members',
          'Prefer practical, hands-on problem solving',
        ];
      case 'ESFP Adventures':
        return [
          'Thrive in social and dynamic environments',
          'Bring excitement and spontaneity to groups',
          'Value present experiences over future planning',
          'Naturally talented at entertaining others',
        ];
      default:
        return [
          'Unique personality dynamics and interactions',
          'Special insights into behavioral patterns',
          'Fascinating aspects of human psychology',
          'Practical applications in daily life',
        ];
    }
  }

  String _getPersonalityAnalysis() {
    final title = widget.topic['title'] as String;
    switch (title) {
      case 'INTJ vs INTJ':
        return 'When two INTJs interact, they find rare mutual understanding. Both appreciate direct communication, intellectual stimulation, and independent thinking. However, they may need to consciously develop emotional expression and compromise skills.';
      case 'ENFP Relationships':
        return 'ENFPs approach relationships with characteristic enthusiasm and idealism. They seek deep, meaningful connections and bring creativity and warmth to their partnerships. Their challenge lies in finding balance between idealism and practical reality.';
      case 'ISTJ at Work':
        return 'ISTJs are the backbone of many organizations, bringing reliability, integrity, and methodical thinking to their roles. They excel in structured environments and contribute through careful attention to detail and consistent follow-through.';
      case 'ESFP Adventures':
        return 'ESFPs live life with infectious enthusiasm and spontaneity. They bring joy and excitement to every situation, making them natural entertainers and social butterflies. Their challenge lies in long-term planning and follow-through.';
      default:
        return 'This topic offers valuable insights into personality dynamics, providing practical understanding for personal growth, relationships, and professional development.';
    }
  }

  List<Map<String, dynamic>> _getRelatedTopics() {
    final title = widget.topic['title'] as String;
    switch (title) {
      case 'INTJ vs INTJ':
        return [
          {'title': 'INTJ Communication', 'color': AppColors.analyst},
          {'title': 'Strategic Thinking', 'color': AppColors.analyst},
          {'title': 'Leadership Styles', 'color': AppColors.sentinel},
        ];
      case 'ENFP Relationships':
        return [
          {'title': 'ENFP Career Paths', 'color': AppColors.diplomat},
          {'title': 'Idealist Partners', 'color': AppColors.diplomat},
          {'title': 'Creative Expression', 'color': AppColors.explorer},
        ];
      case 'ISTJ at Work':
        return [
          {'title': 'Logistician Traits', 'color': AppColors.sentinel},
          {'title': 'Workplace Dynamics', 'color': AppColors.sentinel},
          {'title': 'Professional Growth', 'color': AppColors.analyst},
        ];
      case 'ESFP Adventures':
        return [
          {'title': 'Entertainer Lifestyle', 'color': AppColors.explorer},
          {'title': 'Social Connections', 'color': AppColors.explorer},
          {'title': 'Spontaneous Living', 'color': AppColors.diplomat},
        ];
      default:
        return [
          {'title': 'Personality Types', 'color': AppColors.primary},
          {'title': 'MBTI Basics', 'color': AppColors.primary},
          {'title': 'Self-Discovery', 'color': AppColors.primary},
        ];
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLiked ? 'Liked topic! ❤️' : 'Removed like'),
        duration: const Duration(seconds: 1),
        backgroundColor: _isLiked ? AppColors.error : AppColors.textSecondary,
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Topic saved! 🔖' : 'Bookmark removed'),
        duration: const Duration(seconds: 1),
        backgroundColor: _isBookmarked ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.lg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.textDisabled,
                borderRadius: BorderRadius.circular(AppSpacing.full),
              ),
            ),
            ListTile(
              leading: Icon(Icons.share, color: AppColors.primary),
              title: Text('Share Topic', style: AppTypography.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.link, color: AppColors.primary),
              title: Text('Copy Link', style: AppTypography.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.message, color: AppColors.primary),
              title: Text('Share in Chat', style: AppTypography.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _joinDiscussion() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening discussion... 💬'),
        duration: Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}