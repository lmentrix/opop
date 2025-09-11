import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';

class MatchDetailScreen extends StatefulWidget {
  final Map<String, dynamic> matchData;

  const MatchDetailScreen({
    super.key,
    required this.matchData,
  });

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLiked = false;
  bool _isBookmarked = false;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildProfileContent(),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildSliverAppBar() {
    final gradient = widget.matchData['gradient'] as List<Color>;
    
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: gradient.first,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.xl),
                _buildProfileImages(),
                const SizedBox(height: AppSpacing.md),
                _buildCompatibilityBadge(),
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
          onPressed: _showMoreOptions,
          icon: Icon(
            Icons.more_vert,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImages() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: 3, // Multiple profile images
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.lg),
              border: Border.all(color: AppColors.textInverse, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.matchData['avatar'] as String,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 80,
                  color: AppColors.textInverse,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompatibilityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSpacing.full),
        border: Border.all(color: AppColors.success, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: AppColors.success,
            size: AppSpacing.iconSize * 0.8,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${widget.matchData['compatibility']}% Match',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
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
                _buildBasicInfo(),
                const SizedBox(height: AppSpacing.xl),
                _buildMBTIAnalysis(),
                const SizedBox(height: AppSpacing.xl),
                _buildInterests(),
                const SizedBox(height: AppSpacing.xl),
                _buildDistanceInfo(),
                const SizedBox(height: AppSpacing.xl),
                _buildDescription(),
                const SizedBox(height: AppSpacing.xl * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    final gradient = widget.matchData['gradient'] as List<Color>;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.matchData['name'] as String,
                style: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: gradient.first.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              child: Text(
                widget.matchData['mbtiType'] as String,
                style: AppTypography.labelSmall.copyWith(
                  color: gradient.first,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          widget.matchData['distance'] as String,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildMBTIAnalysis() {
    final gradient = widget.matchData['gradient'] as List<Color>;
    
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
                  color: gradient.first.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Icon(
                  Icons.psychology,
                  color: gradient.first,
                  size: AppSpacing.iconSize,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'MBTI Compatibility',
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
            'Your ${widget.matchData['mbtiType']} personality complements their ${widget.matchData['mbtiType']} nature perfectly. You share similar values and communication styles.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterests() {
    final gradient = widget.matchData['gradient'] as List<Color>;
    final interests = widget.matchData['interests'] as List<String>;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
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
          children: interests.map((interest) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: gradient.first.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.full),
              ),
              child: Text(
                interest,
                style: AppTypography.bodySmall.copyWith(
                  color: gradient.first,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDistanceInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.info,
            size: AppSpacing.iconSize,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.matchData['distance'] as String,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          widget.matchData['description'] as String,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
            letterSpacing: 0.3,
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
                onPressed: _dislike,
                icon: const Icon(Icons.close),
                label: Text(
                  'Pass',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textSecondary,
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
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _startChat,
                icon: const Icon(Icons.chat),
                label: Text(
                  'Start Chat',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _like,
                icon: const Icon(Icons.favorite),
                label: Text(
                  'Like',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
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

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Profile saved! 🔖' : 'Bookmark removed'),
        duration: const Duration(seconds: 1),
        backgroundColor: _isBookmarked ? AppColors.primary : AppColors.textSecondary,
      ),
    );
  }

  void _showMoreOptions() {
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
              title: Text('Share Profile', style: AppTypography.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.block, color: AppColors.error),
              title: Text('Block User', style: AppTypography.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.report, color: AppColors.error),
              title: Text('Report User', style: AppTypography.bodyLarge),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _like() {
    setState(() {
      _isLiked = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Liked! ❤️'),
        duration: Duration(seconds: 1),
        backgroundColor: AppColors.error,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  void _dislike() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passed'),
        duration: Duration(seconds: 1),
        backgroundColor: AppColors.textSecondary,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  void _startChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening chat... 💬'),
        duration: Duration(seconds: 1),
        backgroundColor: AppColors.primary,
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }
}