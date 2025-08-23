import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Privacy settings screen for managing user privacy preferences
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  // Profile Privacy Settings
  bool _profileVisible = true;
  bool _mbtiTypeVisible = true;
  bool _locationVisible = false;
  bool _assessmentResultsVisible = true;
  bool _achievementsVisible = true;

  // Discovery & Matching Settings
  bool _appearInDiscovery = true;
  bool _appearInMatching = true;
  bool _showOnlineStatus = true;
  bool _showLastSeen = false;
  String _matchingRadius = '50km';
  String _ageRange = '18-35';

  // Communication Settings
  bool _allowMessagesFromMatches = true;
  bool _allowMessagesFromFriends = true;
  bool _allowMessagesFromEveryone = false;
  bool _readReceiptsEnabled = true;
  bool _typingIndicatorEnabled = true;

  // Data & Analytics Settings
  bool _personalizedContent = true;
  bool _analyticsEnabled = true;
  bool _crashReporting = true;
  bool _performanceData = true;

  // Account Security Settings
  bool _twoFactorEnabled = false;
  bool _loginNotifications = true;

  final List<String> _radiusOptions = [
    '10km',
    '25km',
    '50km',
    '100km',
    'Unlimited',
  ];
  final List<String> _ageRangeOptions = [
    '18-25',
    '18-35',
    '25-45',
    '35-55',
    '18-99',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: CustomScrollView(slivers: [_buildPrivacyContent()]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: AppSpacing.iconSize,
            ),
          ),
          Expanded(
            child: Text(
              'Privacy Settings',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildPrivacyContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrivacyOverview(),
            const SizedBox(height: AppSpacing.xl),
            _buildProfilePrivacySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildDiscoveryMatchingSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildCommunicationSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildDataAnalyticsSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildAccountSecuritySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildPrivacyActions(),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyOverview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.security,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize * 2,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Your Privacy Matters',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Control who sees your information and how your data is used. You have complete control over your privacy.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textInverse.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePrivacySection() {
    return _buildPrivacySection(
      title: 'Profile Privacy',
      icon: Icons.person,
      color: AppColors.primary,
      description: 'Control what others can see on your profile',
      children: [
        _buildSwitchTile(
          title: 'Profile Visibility',
          subtitle: 'Allow others to find and view your profile',
          value: _profileVisible,
          onChanged: (value) => setState(() => _profileVisible = value),
          icon: Icons.visibility,
        ),
        _buildSwitchTile(
          title: 'MBTI Type Visibility',
          subtitle: 'Show your personality type to others',
          value: _mbtiTypeVisible,
          onChanged: (value) => setState(() => _mbtiTypeVisible = value),
          icon: Icons.psychology,
        ),
        _buildSwitchTile(
          title: 'Location Visibility',
          subtitle: 'Show your location to other users',
          value: _locationVisible,
          onChanged: (value) => setState(() => _locationVisible = value),
          icon: Icons.location_on,
        ),
        _buildSwitchTile(
          title: 'Assessment Results',
          subtitle: 'Share your personality assessment results',
          value: _assessmentResultsVisible,
          onChanged:
              (value) => setState(() => _assessmentResultsVisible = value),
          icon: Icons.quiz,
        ),
        _buildSwitchTile(
          title: 'Achievements & Badges',
          subtitle: 'Display your earned achievements',
          value: _achievementsVisible,
          onChanged: (value) => setState(() => _achievementsVisible = value),
          icon: Icons.emoji_events,
        ),
      ],
    );
  }

  Widget _buildDiscoveryMatchingSection() {
    return _buildPrivacySection(
      title: 'Discovery & Matching',
      icon: Icons.explore,
      color: AppColors.diplomat,
      description: 'Manage how you appear in discovery and matching',
      children: [
        _buildSwitchTile(
          title: 'Appear in Discovery',
          subtitle: 'Show your profile in the discovery feed',
          value: _appearInDiscovery,
          onChanged: (value) => setState(() => _appearInDiscovery = value),
          icon: Icons.explore,
        ),
        _buildSwitchTile(
          title: 'Appear in Matching',
          subtitle: 'Allow others to see you in matching',
          value: _appearInMatching,
          onChanged: (value) => setState(() => _appearInMatching = value),
          icon: Icons.favorite,
        ),
        _buildSwitchTile(
          title: 'Show Online Status',
          subtitle: 'Let others know when you\'re online',
          value: _showOnlineStatus,
          onChanged: (value) => setState(() => _showOnlineStatus = value),
          icon: Icons.circle,
        ),
        _buildSwitchTile(
          title: 'Show Last Seen',
          subtitle: 'Display when you were last active',
          value: _showLastSeen,
          onChanged: (value) => setState(() => _showLastSeen = value),
          icon: Icons.schedule,
        ),
        _buildDropdownTile(
          title: 'Matching Radius',
          subtitle: 'How far to look for matches',
          value: _matchingRadius,
          options: _radiusOptions,
          onChanged: (value) => setState(() => _matchingRadius = value!),
          icon: Icons.location_searching,
        ),
        _buildDropdownTile(
          title: 'Age Range',
          subtitle: 'Age range for potential matches',
          value: _ageRange,
          options: _ageRangeOptions,
          onChanged: (value) => setState(() => _ageRange = value!),
          icon: Icons.cake,
        ),
      ],
    );
  }

  Widget _buildCommunicationSection() {
    return _buildPrivacySection(
      title: 'Communication',
      icon: Icons.chat,
      color: AppColors.explorer,
      description: 'Control who can message you and how',
      children: [
        _buildRadioSection(
          title: 'Who can message you',
          options: [
            RadioOption(
              title: 'Matches Only',
              subtitle: 'Only people you\'ve matched with',
              value:
                  _allowMessagesFromMatches &&
                  !_allowMessagesFromFriends &&
                  !_allowMessagesFromEveryone,
              onChanged: (value) {
                if (value) {
                  setState(() {
                    _allowMessagesFromMatches = true;
                    _allowMessagesFromFriends = false;
                    _allowMessagesFromEveryone = false;
                  });
                }
              },
            ),
            RadioOption(
              title: 'Friends & Matches',
              subtitle: 'People you\'ve friended or matched with',
              value:
                  _allowMessagesFromMatches &&
                  _allowMessagesFromFriends &&
                  !_allowMessagesFromEveryone,
              onChanged: (value) {
                if (value) {
                  setState(() {
                    _allowMessagesFromMatches = true;
                    _allowMessagesFromFriends = true;
                    _allowMessagesFromEveryone = false;
                  });
                }
              },
            ),
            RadioOption(
              title: 'Everyone',
              subtitle: 'Any user can message you',
              value: _allowMessagesFromEveryone,
              onChanged: (value) {
                if (value) {
                  setState(() {
                    _allowMessagesFromMatches = true;
                    _allowMessagesFromFriends = true;
                    _allowMessagesFromEveryone = true;
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _buildSwitchTile(
          title: 'Read Receipts',
          subtitle: 'Let others know when you\'ve read their messages',
          value: _readReceiptsEnabled,
          onChanged: (value) => setState(() => _readReceiptsEnabled = value),
          icon: Icons.done_all,
        ),
        _buildSwitchTile(
          title: 'Typing Indicators',
          subtitle: 'Show when you\'re typing a message',
          value: _typingIndicatorEnabled,
          onChanged: (value) => setState(() => _typingIndicatorEnabled = value),
          icon: Icons.keyboard,
        ),
      ],
    );
  }

  Widget _buildDataAnalyticsSection() {
    return _buildPrivacySection(
      title: 'Data & Analytics',
      icon: Icons.analytics,
      color: AppColors.analyst,
      description: 'Manage how your data is used to improve the app',
      children: [
        _buildSwitchTile(
          title: 'Personalized Content',
          subtitle: 'Use your activity to personalize your experience',
          value: _personalizedContent,
          onChanged: (value) => setState(() => _personalizedContent = value),
          icon: Icons.person_pin,
        ),
        _buildSwitchTile(
          title: 'Analytics Data',
          subtitle: 'Help improve the app with usage analytics',
          value: _analyticsEnabled,
          onChanged: (value) => setState(() => _analyticsEnabled = value),
          icon: Icons.analytics,
        ),
        _buildSwitchTile(
          title: 'Crash Reporting',
          subtitle: 'Automatically send crash reports to improve stability',
          value: _crashReporting,
          onChanged: (value) => setState(() => _crashReporting = value),
          icon: Icons.bug_report,
        ),
        _buildSwitchTile(
          title: 'Performance Data',
          subtitle: 'Share performance data to optimize the app',
          value: _performanceData,
          onChanged: (value) => setState(() => _performanceData = value),
          icon: Icons.speed,
        ),
      ],
    );
  }

  Widget _buildAccountSecuritySection() {
    return _buildPrivacySection(
      title: 'Account Security',
      icon: Icons.shield,
      color: AppColors.sentinel,
      description: 'Secure your account with additional protections',
      children: [
        _buildSwitchTile(
          title: 'Two-Factor Authentication',
          subtitle: 'Add an extra layer of security to your account',
          value: _twoFactorEnabled,
          onChanged: (value) => setState(() => _twoFactorEnabled = value),
          icon: Icons.security,
          trailing:
              _twoFactorEnabled
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(AppSpacing.full),
                    ),
                    child: Text(
                      'Enabled',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  : null,
        ),
        _buildSwitchTile(
          title: 'Login Notifications',
          subtitle: 'Get notified of new login attempts',
          value: _loginNotifications,
          onChanged: (value) => setState(() => _loginNotifications = value),
          icon: Icons.notifications_active,
        ),
        _buildActionTile(
          title: 'Device Management',
          subtitle: 'Manage devices with access to your account',
          icon: Icons.devices,
          onTap: _showDeviceManagement,
        ),
        _buildActionTile(
          title: 'Login History',
          subtitle: 'View recent login activity',
          icon: Icons.history,
          onTap: _showLoginHistory,
        ),
      ],
    );
  }

  Widget _buildPrivacyActions() {
    return Column(
      children: [
        _buildActionButton(
          title: 'Download My Data',
          subtitle: 'Get a copy of all your data',
          icon: Icons.download,
          color: AppColors.info,
          onTap: _downloadData,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildActionButton(
          title: 'Privacy Policy',
          subtitle: 'Read our complete privacy policy',
          icon: Icons.policy,
          color: AppColors.primary,
          onTap: _showPrivacyPolicy,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildActionButton(
          title: 'Delete Account',
          subtitle: 'Permanently delete your account and data',
          icon: Icons.delete_forever,
          color: AppColors.error,
          onTap: _showDeleteAccountDialog,
        ),
      ],
    );
  }

  Widget _buildPrivacySection({
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Icon(icon, color: color, size: AppSpacing.iconSize),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSize,
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
      trailing:
          trailing ??
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSize,
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
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items:
            options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(
                  option,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.textSecondary,
        size: AppSpacing.iconSize,
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

  Widget _buildRadioSection({
    required String title,
    required List<RadioOption> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...options.map(
          (option) => RadioListTile<bool>(
            value: true,
            groupValue: option.value,
            onChanged: (_) => option.onChanged(true),
            title: Text(
              option.title,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            subtitle: Text(
              option.subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
            activeColor: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Icon(icon, color: color, size: AppSpacing.iconSize),
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
      ),
    );
  }

  // Action methods
  void _showDeviceManagement() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Device management coming soon!')),
    );
  }

  void _showLoginHistory() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Login history coming soon!')));
  }

  void _downloadData() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data download initiated!')));
  }

  void _showPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy policy coming soon!')),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Delete Account',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This action cannot be undone. Deleting your account will:',
                  style: AppTypography.bodyMedium.copyWith(letterSpacing: 0.3),
                ),
                const SizedBox(height: AppSpacing.md),
                ...[
                  'Permanently delete all your data',
                  'Remove your profile from discovery',
                  'Delete all your conversations',
                  'Cancel any active subscriptions',
                ].map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.close, color: AppColors.error, size: 16),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            item,
                            style: AppTypography.bodySmall.copyWith(
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deletion cancelled')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.textInverse,
                ),
                child: Text(
                  'Delete Account',
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

class RadioOption {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  RadioOption({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
}
