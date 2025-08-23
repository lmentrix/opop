import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Matching screen for MBTI compatibility
class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late Animation<double> _cardAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentIndex = 0;
  final List<Map<String, dynamic>> _matches = [
    {
      'name': 'Sarah Chen',
      'age': 24,
      'mbtiType': 'ENFP',
      'avatar': '🎨',
      'compatibility': 95,
      'distance': '2.3 km away',
      'interests': ['Art', 'Psychology', 'Travel', 'Photography', 'Music'],
      'gradient': [AppColors.diplomat, AppColors.diplomat.withOpacity(0.7)],
      'description':
          'Creative soul who loves deep conversations about personality types and exploring new artistic expressions.',
      'photos': ['🎨', '🌅', '📚', '🎭'],
      'quote':
          'Life is a canvas, and I\'m here to paint it with all the colors of my emotions! 🎨✨',
    },
    {
      'name': 'Alex Rodriguez',
      'age': 27,
      'mbtiType': 'INFJ',
      'avatar': '📚',
      'compatibility': 88,
      'distance': '5.1 km away',
      'interests': ['Books', 'Philosophy', 'Music', 'Writing', 'Nature'],
      'gradient': [AppColors.diplomat, AppColors.primary],
      'description':
          'Passionate about understanding human nature and creating meaningful connections through shared experiences.',
      'photos': ['📚', '🌲', '🎼', '✍️'],
      'quote':
          'Seeking someone who appreciates the beauty in quiet moments and deep conversations.',
    },
    {
      'name': 'Jordan Kim',
      'age': 26,
      'mbtiType': 'ENTP',
      'avatar': '💡',
      'compatibility': 92,
      'distance': '1.8 km away',
      'interests': [
        'Innovation',
        'Debates',
        'Technology',
        'Startups',
        'Gaming',
      ],
      'gradient': [AppColors.analyst, AppColors.diplomat],
      'description':
          'Love exploring new ideas and challenging conventional thinking. Always up for a good intellectual debate!',
      'photos': ['💡', '🚀', '🎮', '🧠'],
      'quote':
          'Let\'s build something amazing together - whether it\'s a startup or just great memories!',
    },
    {
      'name': 'Emma Davis',
      'age': 23,
      'mbtiType': 'ISFP',
      'avatar': '🎭',
      'compatibility': 85,
      'distance': '3.2 km away',
      'interests': ['Art', 'Theater', 'Animals', 'Volunteering', 'Yoga'],
      'gradient': [AppColors.explorer, AppColors.explorer.withOpacity(0.7)],
      'description':
          'Gentle soul with a passion for the arts and helping others. I believe in living authentically.',
      'photos': ['🎭', '🐕', '🧘‍♀️', '🌸'],
      'quote':
          'Looking for someone who values kindness and appreciates life\'s simple pleasures.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _handleSwipe(bool isLike) {
    if (_currentIndex >= _matches.length) return;

    _cardController.forward().then((_) {
      setState(() {
        _currentIndex++;
      });
      _cardController.reset();

      if (isLike) {
        _showMatchDialog();
      }
    });
  }

  void _showMatchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.lg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🎉',
                    style: AppTypography.displayLarge.copyWith(fontSize: 60),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'It\'s a Match!',
                    style: AppTypography.headlineLarge.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'You and ${_matches[_currentIndex - 1]['name']} liked each other!',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textInverse.withOpacity(0.9),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textInverse,
                            side: const BorderSide(
                              color: AppColors.textInverse,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.full,
                              ),
                            ),
                          ),
                          child: Text(
                            'Keep Swiping',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Navigate to chat
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textInverse,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.full,
                              ),
                            ),
                          ),
                          child: Text(
                            'Send Message',
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child:
                  _currentIndex >= _matches.length
                      ? _buildNoMoreMatches()
                      : _buildMatchingCards(),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: AppSpacing.iconSize,
            ),
          ),
          Expanded(
            child: Text(
              'MBTI Matching',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _showFilters,
            icon: Icon(
              Icons.tune,
              color: AppColors.textPrimary,
              size: AppSpacing.iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingCards() {
    return Expanded(
      child: Stack(
        children: [
          if (_currentIndex + 1 < _matches.length)
            _buildMatchCard(_matches[_currentIndex + 1], isBackground: true),
          AnimatedBuilder(
            animation: _cardController,
            builder: (context, child) {
              return Transform.scale(
                scale: _cardAnimation.value,
                child: Transform.translate(
                  offset:
                      _slideAnimation.value * MediaQuery.of(context).size.width,
                  child: _buildMatchCard(_matches[_currentIndex]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(
    Map<String, dynamic> match, {
    bool isBackground = false,
  }) {
    final gradient = match['gradient'] as List<Color>;

    return Container(
      margin: EdgeInsets.all(isBackground ? AppSpacing.xl : AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(isBackground ? 0.05 : 0.15),
            blurRadius: isBackground ? 10 : 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        match['avatar'] as String,
                        style: AppTypography.displayLarge.copyWith(
                          fontSize: 120,
                          color: AppColors.textInverse.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(AppSpacing.full),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          '${match['compatibility']}% Match',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textInverse,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: AppSpacing.md,
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${match['name']}, ${match['age']}',
                                style: AppTypography.headlineMedium.copyWith(
                                  color: AppColors.textInverse,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textInverse.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.xs,
                                  ),
                                ),
                                child: Text(
                                  match['mbtiType'] as String,
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.textInverse,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            match['distance'] as String,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textInverse.withOpacity(0.9),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: gradient.first.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        border: Border.all(
                          color: gradient.first.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        match['quote'] as String,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      match['description'] as String,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children:
                          (match['interests'] as List<String>).take(4).map((
                            interest,
                          ) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: gradient.first.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.full,
                                ),
                              ),
                              child: Text(
                                interest,
                                style: AppTypography.labelSmall.copyWith(
                                  color: gradient.first,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.close,
            color: AppColors.error,
            onTap: () => _handleSwipe(false),
            size: 60,
          ),
          _buildActionButton(
            icon: Icons.star,
            color: AppColors.warning,
            onTap: _showSuperLike,
            size: 50,
          ),
          _buildActionButton(
            icon: Icons.favorite,
            color: AppColors.success,
            onTap: () => _handleSwipe(true),
            size: 60,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSpacing.full),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textInverse, size: size * 0.4),
      ),
    );
  }

  Widget _buildNoMoreMatches() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🎯', style: AppTypography.displayLarge.copyWith(fontSize: 80)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No More Matches',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Check back later for new potential matches!',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back to Discovery',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    // TODO: Implement filters
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Filters coming soon!')));
  }

  void _showSuperLike() {
    // TODO: Implement super like
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Super Like sent! ⭐')));
  }
}







