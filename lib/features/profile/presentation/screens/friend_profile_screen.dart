import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';
import 'package:opop/features/profile/data/models/friend_profile.dart';
import 'package:opop/features/profile/data/models/user_profile.dart';
import 'package:opop/features/profile/presentation/widgets/achievement_badge.dart';
import 'package:opop/features/profile/presentation/widgets/personality_card.dart';
import 'package:opop/features/profile/presentation/widgets/profile_section.dart';

class FriendProfileScreen extends StatefulWidget {
  final FriendProfile? friendProfile;
  
  const FriendProfileScreen({
    super.key,
    this.friendProfile,
  });

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  FriendProfile? _friendProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadFriendProfile();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
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

  void _loadFriendProfile() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _friendProfile = widget.friendProfile ?? _createDummyFriendProfile();
          _isLoading = false;
        });
      }
    });
  }

  FriendProfile _createDummyFriendProfile() {
    return const FriendProfile(
      id: 'friend_001',
      name: 'Sarah Chen',
      avatar: '🌟',
      mbtiType: 'ENFP',
      status: 'Active',
      conversationCount: 12,
    );
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
        slivers: [_buildSliverAppBar(), _buildProfileContent()],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.diplomat,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.xl),
                _buildProfileAvatar(),
                const SizedBox(height: AppSpacing.md),
                if (_friendProfile != null) ...[
                  Text(
                    _friendProfile!.name,
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    _friendProfile!.mbtiType,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textInverse.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ),
                  if (_friendProfile!.status != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                      child: Text(
                        _friendProfile!.status!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textInverse,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
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

  Widget _buildProfileAvatar() {
    if (_isLoading) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.textInverse.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppSpacing.full),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.textInverse,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.textInverse,
        borderRadius: BorderRadius.circular(AppSpacing.full),
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
          _friendProfile!.avatar,
          style: AppTypography.displaySmall.copyWith(fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                _buildQuickStats(),
                const SizedBox(height: AppSpacing.xl),
                _buildPersonalityInsights(),
                const SizedBox(height: AppSpacing.xl),
                _buildFriendAchievements(),
                const SizedBox(height: AppSpacing.xl),
                _buildFriendActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.chat_bubble,
              value: _friendProfile?.conversationCount.toString() ?? '0',
              label: 'Chats',
              color: AppColors.diplomat,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _buildStatItem(
              icon: Icons.psychology,
              value: _friendProfile?.mbtiType ?? 'INTJ',
              label: 'Personality',
              color: AppColors.analyst,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _buildStatItem(
              icon: Icons.timeline,
              value: _getFriendStatus(),
              label: 'Status',
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          child: Icon(icon, color: color, size: AppSpacing.iconSize),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  String _getFriendStatus() {
    if (_friendProfile?.status?.toLowerCase() == 'active') {
      return 'Online';
    } else if (_friendProfile?.lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(_friendProfile!.lastSeen!);
      if (difference.inHours < 1) {
        return 'Recent';
      } else if (difference.inDays < 1) {
        return 'Today';
      } else {
        return 'Offline';
      }
    }
    return 'Offline';
  }

  Widget _buildPersonalityInsights() {
    return ProfileSection(
      title: 'Personality Insights',
      icon: Icons.psychology,
      color: AppColors.analyst,
      child: PersonalityCard(
        mbtiType: _friendProfile?.mbtiType ?? 'ENFP',
        description: _friendProfile?.personalityDescription ?? '',
        strengths: _friendProfile?.strengths ?? [],
        weaknesses: _friendProfile?.weaknesses ?? [],
      ),
    );
  }

  Widget _buildFriendAchievements() {
    return ProfileSection(
      title: 'Recent Achievements',
      icon: Icons.emoji_events,
      color: AppColors.explorer,
      child: _buildAchievementGrid(),
    );
  }

  Widget _buildAchievementGrid() {
    final achievements = _createDummyAchievements();
    
    if (achievements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 48,
              color: AppColors.textDisabled,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No achievements yet',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This friend hasn\'t earned any achievements yet.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return AchievementBadge(
          achievement: achievement,
          onTap: () => _showAchievementDetails(achievement),
        );
      },
    );
  }

  List<Achievement> _createDummyAchievements() {
    return [
      Achievement(
        id: 'ach_001',
        name: 'Chat Master',
        description: 'Had 10+ conversations',
        icon: '💬',
        color: 'diplomat',
        unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Achievement(
        id: 'ach_002',
        name: 'Personality Pro',
        description: 'Completed personality assessment',
        icon: '🧠',
        color: 'analyst',
        unlockedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Achievement(
        id: 'ach_003',
        name: 'Social Butterfly',
        description: 'Connected with 5+ friends',
        icon: '🦋',
        color: 'explorer',
        unlockedAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  Widget _buildFriendActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _startChat,
                icon: const Icon(Icons.chat),
                label: Text(
                  'Chat',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.diplomat,
                  foregroundColor: AppColors.textInverse,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addFriend,
                icon: const Icon(Icons.person_add),
                label: Text(
                  'Add Friend',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.textInverse,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _viewMutualFriends,
            icon: const Icon(Icons.group),
            label: Text(
              'View Mutual Friends',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
            ),
          ),
        ),
      ],
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
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppSpacing.full),
              ),
            ),
            ListTile(
              leading: Icon(Icons.share, color: AppColors.primary),
              title: Text('Share Profile', style: AppTypography.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _shareProfile();
              },
            ),
            ListTile(
              leading: Icon(Icons.block, color: AppColors.error),
              title: Text('Block User', style: AppTypography.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _blockUser();
              },
            ),
            ListTile(
              leading: Icon(Icons.report, color: AppColors.error),
              title: Text('Report User', style: AppTypography.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _reportUser();
              },
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _startChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting chat...')),
    );
  }

  void _addFriend() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request sent!')),
    );
  }

  void _viewMutualFriends() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loading mutual friends...')),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing profile...')),
    );
  }

  void _blockUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Block User',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        content: Text(
          'Are you sure you want to block this user?',
          style: AppTypography.bodyMedium.copyWith(letterSpacing: 0.3),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User blocked')),
              );
            },
            child: Text(
              'Block',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _reportUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Report User',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        content: Text(
          'Are you sure you want to report this user?',
          style: AppTypography.bodyMedium.copyWith(letterSpacing: 0.3),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User reported')),
              );
            },
            child: Text(
              'Report',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          achievement.name,
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        content: Text(
          achievement.description,
          style: AppTypography.bodyMedium.copyWith(letterSpacing: 0.3),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
