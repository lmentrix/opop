import 'package:flutter/material.dart';
import 'package:opop/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:opop/features/profile/presentation/screens/profile_provider.dart';
import 'package:opop/features/settings/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/models/user_profile.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/personality_card.dart';
import '../widgets/profile_section.dart';

/// User profile screen for MBTI Explorer app
/// Features fashion-styled typography with MBTI theme integration
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserProfile();
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

  void _loadUserProfile() {
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // Load dummy user data
        final userData = UserProfile.dummyData();

        setState(() {
          _userProfile = userData;
          _isLoading = false;
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
        slivers: [_buildSliverAppBar(), _buildProfileContent()],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.xl),
                _buildProfileAvatar(),
                const SizedBox(height: AppSpacing.md),
                if (_userProfile != null) ...[
                  Text(
                    _userProfile!.displayName,
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textInverse,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    _userProfile!.mbtiType,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textInverse.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                    ),
                  ),
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
          onPressed: _showEditProfile,
          icon: Icon(
            Icons.edit,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize,
          ),
        ),
        IconButton(
          onPressed: _showSettings,
          icon: Icon(
            Icons.settings,
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

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        return GestureDetector(
          onTap: _changeProfilePicture,
          child: Container(
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
                profileProvider.selectedAvatar,
                style: AppTypography.displaySmall.copyWith(fontSize: 40),
              ),
            ),
          ),
        );
      },
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
                _buildAchievements(),
                const SizedBox(height: AppSpacing.xl),
                _buildPersonalInfo(),
                const SizedBox(height: AppSpacing.xl),
                _buildPreferences(),
                const SizedBox(height: AppSpacing.xl),
                _buildActions(),
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
              icon: Icons.psychology,
              value: _userProfile?.assessmentCount.toString() ?? '0',
              label: 'Assessments',
              color: AppColors.analyst,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _buildStatItem(
              icon: Icons.chat_bubble,
              value: _userProfile?.conversationCount.toString() ?? '0',
              label: 'Conversations',
              color: AppColors.diplomat,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.divider),
          Expanded(
            child: _buildStatItem(
              icon: Icons.emoji_events,
              value: _userProfile?.achievementCount.toString() ?? '0',
              label: 'Achievements',
              color: AppColors.explorer,
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

  Widget _buildPersonalityInsights() {
    return ProfileSection(
      title: 'Personality Insights',
      icon: Icons.psychology,
      color: AppColors.analyst,
      child: PersonalityCard(
        mbtiType: _userProfile?.mbtiType ?? 'INTJ',
        description: _userProfile?.personalityDescription ?? '',
        strengths: _userProfile?.strengths ?? [],
        weaknesses: _userProfile?.weaknesses ?? [],
      ),
    );
  }

  Widget _buildAchievements() {
    return ProfileSection(
      title: 'Achievements & Badges',
      icon: Icons.emoji_events,
      color: AppColors.explorer,
      child: Column(
        children: [
          if (_userProfile?.achievements.isNotEmpty ?? false) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 1,
              ),
              itemCount: _userProfile!.achievements.length,
              itemBuilder: (context, index) {
                final achievement = _userProfile!.achievements[index];
                return AchievementBadge(
                  achievement: achievement,
                  onTap: () => _showAchievementDetails(achievement),
                );
              },
            ),
          ] else ...[
            Container(
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
                    'Complete assessments and engage in conversations to earn badges!',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return ProfileSection(
      title: 'Personal Information',
      icon: Icons.person,
      color: AppColors.primary,
      child: Column(
        children: [
          _buildInfoRow('Full Name', _userProfile?.fullName ?? ''),
          _buildInfoRow('Username', _userProfile?.username ?? ''),
          _buildInfoRow('Email', _userProfile?.email ?? ''),
          _buildInfoRow('Location', _userProfile?.location ?? ''),
          _buildInfoRow('Joined', _userProfile?.joinDate ?? ''),
          _buildInfoRow('Bio', _userProfile?.bio ?? ''),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not specified' : value,
              style: AppTypography.bodyMedium.copyWith(
                color: value.isEmpty
                    ? AppColors.textDisabled
                    : AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
    return ProfileSection(
      title: 'Preferences & Settings',
      icon: Icons.tune,
      color: AppColors.sentinel,
      child: Column(
        children: [
          _buildPreferenceItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage your notification preferences',
            onTap: _showNotificationSettings,
          ),
          _buildPreferenceItem(
            icon: Icons.privacy_tip,
            title: 'Privacy',
            subtitle: 'Control your privacy settings',
            onTap: _showPrivacySettings,
          ),
          _buildPreferenceItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: _showLanguageSettings,
          ),
          _buildPreferenceItem(
            icon: Icons.dark_mode,
            title: 'Theme',
            subtitle: 'Auto (follows system)',
            onTap: _showThemeSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.sentinel.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Icon(icon, color: AppColors.sentinel, size: AppSpacing.iconSize),
      ),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 0.2,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSize,
      ),
      onTap: onTap,
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _startNewAssessment,
            icon: const Icon(Icons.psychology),
            label: Text(
              'Start New Assessment',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
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
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _shareProfile,
            icon: const Icon(Icons.share),
            label: Text(
              'Share Profile',
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
        const SizedBox(height: AppSpacing.lg),
        TextButton(
          onPressed: _signOut,
          child: Text(
            'Sign Out',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  // Action methods
  void _showEditProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const EditProfileScreen()));
  }

  void _showSettings() {
    // TODO: Implement settings
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Settings coming soon!')));
  }

  void _changeProfilePicture() {
    // Navigate to edit profile screen with a focus on changing the profile picture
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const EditProfileScreen()));
  }

  void _showAchievementDetails(dynamic achievement) {
    // TODO: Implement achievement details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Achievement: ${achievement.toString()}')),
    );
  }

  void _showNotificationSettings() {
    // TODO: Implement notification settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings coming soon!')),
    );
  }

  void _showPrivacySettings() {
    // TODO: Implement privacy settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings coming soon!')),
    );
  }

  void _showLanguageSettings() {
    // TODO: Implement language settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language settings coming soon!')),
    );
  }

  void _showThemeSettings() {
    // TODO: Implement theme settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme settings coming soon!')),
    );
  }

  void _startNewAssessment() {
    // TODO: Navigate to assessment
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Starting new assessment...')));
  }

  void _shareProfile() {
    // TODO: Implement profile sharing
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sharing profile...')));
  }

  void _signOut() {
    // TODO: Implement sign out
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        content: Text(
          'Are you sure you want to sign out?',
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
              // TODO: Implement sign out logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            child: Text(
              'Sign Out',
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
}
