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
  
  // Filter state
  List<Map<String, dynamic>> _filteredMatches = [];
  Set<String> _selectedMBTITypes = {};
  RangeValues _ageRange = const RangeValues(18, 35);
  RangeValues _compatibilityRange = const RangeValues(70, 100);
  double _maxDistance = 10.0;
  Set<String> _selectedInterests = {};
  bool _filtersApplied = false;

  // All available matches
  final List<Map<String, dynamic>> _allMatches = [
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

  // All MBTI types for filtering
  static const List<String> _allMBTITypes = [
    'INTJ', 'INTP', 'ENTJ', 'ENTP',
    'INFJ', 'INFP', 'ENFJ', 'ENFP',
    'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ',
    'ISTP', 'ISFP', 'ESTP', 'ESFP',
  ];

  // All interests for filtering
  static const List<String> _allInterests = [
    'Art', 'Psychology', 'Travel', 'Photography', 'Music',
    'Books', 'Philosophy', 'Writing', 'Nature', 'Innovation',
    'Debates', 'Technology', 'Startups', 'Gaming', 'Theater',
    'Animals', 'Volunteering', 'Yoga', 'Sports', 'Cooking',
    'Movies', 'Dancing', 'Hiking', 'Fitness', 'Meditation',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeFilteredMatches();
  }

  void _initializeFilteredMatches() {
    _filteredMatches = List.from(_allMatches);
  }

  void _initializeAnimations() {
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cardAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(1.5, 0)).animate(
          CurvedAnimation(parent: _cardController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _handleSwipe(bool isLike) {
    if (_currentIndex >= _filteredMatches.length) return;

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
      builder: (context) => Dialog(
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
                'You and ${_filteredMatches[_currentIndex - 1]['name']} liked each other!',
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
                          borderRadius: BorderRadius.circular(AppSpacing.full),
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
                          borderRadius: BorderRadius.circular(AppSpacing.full),
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
              child: _currentIndex >= _filteredMatches.length
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
          // REMOVED the back button IconButton
          Expanded(
            child: Column(
              children: [
                Text(
                  'MBTI Matching',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_filtersApplied)
                  Text(
                    '${_filteredMatches.length} potential matches',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: _showFilters,
                icon: Icon(
                  Icons.tune,
                  color: AppColors.textPrimary,
                  size: AppSpacing.iconSize,
                ),
              ),
              if (_filtersApplied)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.full),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchingCards() {
    return Expanded(
      child: Stack(
        children: [
          if (_currentIndex + 1 < _filteredMatches.length)
            _buildMatchCard(_filteredMatches[_currentIndex + 1], isBackground: true),
          AnimatedBuilder(
            animation: _cardController,
            builder: (context, child) {
              return Transform.scale(
                scale: _cardAnimation.value,
                child: Transform.translate(
                  offset:
                      _slideAnimation.value * MediaQuery.of(context).size.width,
                  child: _buildMatchCard(_filteredMatches[_currentIndex]),
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
              flex: 3,
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
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      match['description'] as String,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: (match['interests'] as List<String>)
                          .take(4)
                          .map((interest) {
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
                          })
                          .toList(),
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
          Text(_filtersApplied ? '🔍' : '🎯', 
               style: AppTypography.displayLarge.copyWith(fontSize: 80)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            _filtersApplied ? 'No Matches Found' : 'No More Matches',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _filtersApplied
                ? 'Try adjusting your filters to see more matches.'
                : 'Check back later for new potential matches!',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_filtersApplied)
            ElevatedButton(
              onPressed: _clearFilters,
              child: Text(
                'Clear Filters',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.lg),
              topRight: Radius.circular(AppSpacing.lg),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Filter Matches',
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (_filtersApplied)
                      TextButton(
                        onPressed: () {
                          _clearFilters();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Clear All',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Filter options
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // MBTI Type Filter
                      _buildMBTIFilterSection(setState),
                      SizedBox(height: AppSpacing.lg),
                      
                      // Age Range Filter
                      _buildAgeRangeFilter(setState),
                      SizedBox(height: AppSpacing.lg),
                      
                      // Compatibility Range Filter
                      _buildCompatibilityRangeFilter(setState),
                      SizedBox(height: AppSpacing.lg),
                      
                      // Distance Filter
                      _buildDistanceFilter(setState),
                      SizedBox(height: AppSpacing.lg),
                      
                      // Interests Filter
                      _buildInterestsFilter(setState),
                      SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
              
              // Action buttons
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.full),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _applyFilters();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.full),
                          ),
                        ),
                        child: Text(
                          'Apply Filters',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuperLike() {
    // TODO: Implement super like
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Super Like sent! ⭐')));
  }

  // Filter section builders
  Widget _buildMBTIFilterSection(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MBTI Types',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: _allMBTITypes.map((type) {
            final isSelected = _selectedMBTITypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedMBTITypes.add(type);
                  } else {
                    _selectedMBTITypes.remove(type);
                  }
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAgeRangeFilter(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Age Range: ${_ageRange.start.round()} - ${_ageRange.end.round()}',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        RangeSlider(
          values: _ageRange,
          min: 18,
          max: 65,
          divisions: 47,
          labels: RangeLabels(
            _ageRange.start.round().toString(),
            _ageRange.end.round().toString(),
          ),
          onChanged: (values) {
            setState(() {
              _ageRange = values;
            });
          },
          activeColor: AppColors.primary,
          inactiveColor: AppColors.outline.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildCompatibilityRangeFilter(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Compatibility: ${_compatibilityRange.start.round()}% - ${_compatibilityRange.end.round()}%',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        RangeSlider(
          values: _compatibilityRange,
          min: 0,
          max: 100,
          divisions: 20,
          labels: RangeLabels(
            '${_compatibilityRange.start.round()}%',
            '${_compatibilityRange.end.round()}%',
          ),
          onChanged: (values) {
            setState(() {
              _compatibilityRange = values;
            });
          },
          activeColor: AppColors.success,
          inactiveColor: AppColors.outline.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildDistanceFilter(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maximum Distance: ${_maxDistance.round()} km',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Slider(
          value: _maxDistance,
          min: 1,
          max: 100,
          divisions: 99,
          label: '${_maxDistance.round()} km',
          onChanged: (value) {
            setState(() {
              _maxDistance = value;
            });
          },
          activeColor: AppColors.warning,
          inactiveColor: AppColors.outline.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildInterestsFilter(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interests',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: _allInterests.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInterests.add(interest);
                  } else {
                    _selectedInterests.remove(interest);
                  }
                });
              },
              selectedColor: AppColors.diplomat.withOpacity(0.2),
              checkmarkColor: AppColors.diplomat,
            );
          }).toList(),
        ),
      ],
    );
  }

  // Filter logic methods
  void _applyFilters() {
    setState(() {
      _filteredMatches = _allMatches.where((match) {
        // Check MBTI type filter
        if (_selectedMBTITypes.isNotEmpty &&
            !_selectedMBTITypes.contains(match['mbtiType'])) {
          return false;
        }

        // Check age range filter
        final age = match['age'] as int;
        if (age < _ageRange.start || age > _ageRange.end) {
          return false;
        }

        // Check compatibility range filter
        final compatibility = match['compatibility'] as int;
        if (compatibility < _compatibilityRange.start ||
            compatibility > _compatibilityRange.end) {
          return false;
        }

        // Check distance filter (simplified - assume distance string contains number)
        final distanceString = match['distance'] as String;
        final distanceNumber = _extractDistanceNumber(distanceString);
        if (distanceNumber > _maxDistance) {
          return false;
        }

        // Check interests filter
        if (_selectedInterests.isNotEmpty) {
          final matchInterests = match['interests'] as List<String>;
          final hasMatchingInterest = _selectedInterests.any((interest) =>
              matchInterests.any((matchInterest) =>
                  matchInterest.toLowerCase().contains(interest.toLowerCase())));
          if (!hasMatchingInterest) {
            return false;
          }
        }

        return true;
      }).toList();

      _currentIndex = 0;
      _filtersApplied = _selectedMBTITypes.isNotEmpty ||
          _ageRange != const RangeValues(18, 35) ||
          _compatibilityRange != const RangeValues(70, 100) ||
          _maxDistance != 10.0 ||
          _selectedInterests.isNotEmpty;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Found ${_filteredMatches.length} matches!'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedMBTITypes.clear();
      _ageRange = const RangeValues(18, 35);
      _compatibilityRange = const RangeValues(70, 100);
      _maxDistance = 10.0;
      _selectedInterests.clear();
      _filtersApplied = false;
      _filteredMatches = List.from(_allMatches);
      _currentIndex = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filters cleared!'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  double _extractDistanceNumber(String distanceString) {
    // Extract numeric value from distance string like "2.3 km away"
    final regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(distanceString);
    if (match != null) {
      return double.parse(match.group(1)!);
    }
    return 0.0;
  }
}
