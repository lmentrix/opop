import 'package:flutter/material.dart';
import 'package:opop/features/settings/presentation/screens/about_screen.dart';
import 'package:opop/features/settings/presentation/screens/signout_screen.dart';
import 'package:opop/features/settings/presentation/screens/support_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../profile/presentation/screens/edit_profile_screen.dart';
import 'privacy_screen.dart';
import 'notifications_screen.dart';
import 'theme_screen.dart';
import 'language_screen.dart';
import 'accessibility_screen.dart';
import 'support_screen.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [_buildSliverAppBar(), _buildSettingsContent()],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
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
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Settings',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'Customize your experience',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textInverse.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsContent() {
    return SliverToBoxAdapter(
      child: Builder(
        builder:
            (context) => Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Account'),
                  const SizedBox(height: AppSpacing.md),
                  _buildAccountSettings(context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle('Preferences'),
                  const SizedBox(height: AppSpacing.md),
                  _buildPreferenceSettings(context),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionTitle('Support'),
                  const SizedBox(height: AppSpacing.md),
                  _buildSupportSettings(context),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.titleLarge.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.person,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          onTap: () => _navigateToEditProfile(context),
        ),
        _buildSettingItem(
          icon: Icons.security,
          title: 'Privacy',
          subtitle: 'Manage your privacy settings',
          onTap: () => _navigateToPrivacy(context),
        ),
        _buildSettingItem(
          icon: Icons.notifications,
          title: 'Notifications',
          subtitle: 'Configure notification preferences',
          onTap: () => _navigateToNotifications(context),
        ),
      ],
    );
  }

  Widget _buildPreferenceSettings(BuildContext context) {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.dark_mode,
          title: 'Theme',
          subtitle: 'Light, Dark, or Auto',
          onTap: () => _navigateToTheme(context),
        ),
        _buildSettingItem(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'English (US)',
          onTap: () => _navigateToLanguage(context),
        ),
        _buildSettingItem(
          icon: Icons.accessibility,
          title: 'Accessibility',
          subtitle: 'Font size and contrast',
          onTap: () => _navigateToAccessibility(context),
        ),
      ],
    );
  }

  Widget _buildSupportSettings(BuildContext context) {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'Get help and contact support',
          onTap: () => _navigateToSupportScreen(context),
        ),
        _buildSettingItem(
          icon: Icons.info,
          title: 'About',
          subtitle: 'App version and information',
          onTap: () => _navigateToAboutScreen(context),
        ),
        _buildSettingItem(
          icon: Icons.logout,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          onTap: () => _navigateToSighoutScreen(context),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color:
              isDestructive
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
          size: AppSpacing.iconSize,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
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

  void _navigateToEditProfile(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const EditProfileScreen()));
  }

  void _navigateToPrivacy(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const PrivacyScreen()));
  }

  void _navigateToNotifications(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
    );
  }

  void _navigateToTheme(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ThemeScreen()));
  }

  void _navigateToLanguage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LanguageScreen()));
  }

  void _navigateToAccessibility(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AccessibilityScreen()),
    );
  }

  void _navigateToSupportScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SupportScreen()));
  }

  void _navigateToAboutScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AboutScreen()));
  }

  void _navigateToSighoutScreen(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const SignoutScreen()));
  }
}
