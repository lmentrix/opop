import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import 'notification_demo_screen.dart';

/// Notifications settings screen for managing notification preferences
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Push Notification Settings
  bool _pushNotificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _ledEnabled = false;
  String _notificationSound = 'Default';

  // Message Notifications
  bool _newMessagesEnabled = true;
  bool _messageRepliesEnabled = true;
  bool _groupMessagesEnabled = true;
  bool _messagePreviewEnabled = false;

  // Matching & Discovery Notifications
  bool _newMatchesEnabled = true;
  bool _likedProfileEnabled = true;
  bool _profileViewsEnabled = false;
  bool _superLikesEnabled = true;

  // Social Notifications
  bool _friendRequestsEnabled = true;
  bool _friendAcceptedEnabled = true;
  bool _commentsEnabled = true;
  bool _likesEnabled = false;
  bool _sharesEnabled = true;

  // MBTI & Assessment Notifications
  bool _assessmentRemindersEnabled = true;
  bool _personalityInsightsEnabled = true;
  bool _compatibilityUpdatesEnabled = true;
  bool _mbtiNewsEnabled = false;

  // System Notifications
  bool _securityAlertsEnabled = true;
  bool _accountUpdatesEnabled = true;
  bool _appUpdatesEnabled = false;
  bool _maintenanceNoticesEnabled = true;

  // Quiet Hours
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);

  // Notification Frequency
  String _emailFrequency = 'Daily';
  String _pushFrequency = 'Immediately';

  final List<String> _soundOptions = [
    'Default',
    'Gentle Bell',
    'MBTI Chime',
    'Soft Ping',
    'Nature Sound',
    'Silent',
  ];

  final List<String> _frequencyOptions = [
    'Immediately',
    'Every 15 minutes',
    'Every hour',
    'Daily digest',
    'Weekly digest',
  ];

  final List<String> _emailFrequencyOptions = [
    'Never',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: CustomScrollView(slivers: [_buildNotificationsContent()]),
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
              'Notifications',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _openDemoScreen,
                icon: Icon(
                  Icons.science,
                  color: AppColors.analyst,
                  size: AppSpacing.iconSize,
                ),
              ),
              IconButton(
                onPressed: _testNotification,
                icon: Icon(
                  Icons.notifications_active,
                  color: AppColors.primary,
                  size: AppSpacing.iconSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationOverview(),
            const SizedBox(height: AppSpacing.xl),
            _buildPushNotificationSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildMessageNotificationsSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildMatchingDiscoverySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildSocialNotificationsSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildMBTIAssessmentSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildSystemNotificationsSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildQuietHoursSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildNotificationFrequencySection(),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationOverview() {
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
            Icons.notifications,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize * 2,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Stay Connected',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Customize your notifications to stay updated on matches, messages, and MBTI insights.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textInverse.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _testNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textInverse,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.full),
                    ),
                  ),
                  child: Text(
                    'Test Notification',
                    style: AppTypography.labelLarge.copyWith(
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
    );
  }

  Widget _buildPushNotificationSection() {
    return _buildNotificationSection(
      title: 'Push Notifications',
      icon: Icons.phone_android,
      color: AppColors.primary,
      description: 'Control how notifications appear on your device',
      children: [
        _buildSwitchTile(
          title: 'Push Notifications',
          subtitle: 'Enable notifications on this device',
          value: _pushNotificationsEnabled,
          onChanged: (value) {
            setState(() => _pushNotificationsEnabled = value);
            _handlePushNotificationToggle(value);
          },
          icon: Icons.notifications,
        ),
        if (_pushNotificationsEnabled) ...[
          _buildSwitchTile(
            title: 'Sound',
            subtitle: 'Play sound for notifications',
            value: _soundEnabled,
            onChanged: (value) => setState(() => _soundEnabled = value),
            icon: Icons.volume_up,
          ),
          _buildDropdownTile(
            title: 'Notification Sound',
            subtitle: 'Choose your notification sound',
            value: _notificationSound,
            options: _soundOptions,
            onChanged: (value) {
              setState(() => _notificationSound = value!);
              _playNotificationSound(value!);
            },
            icon: Icons.music_note,
          ),
          _buildSwitchTile(
            title: 'Vibration',
            subtitle: 'Vibrate for notifications',
            value: _vibrationEnabled,
            onChanged: (value) {
              setState(() => _vibrationEnabled = value);
              if (value) _testVibration();
            },
            icon: Icons.vibration,
          ),
          _buildSwitchTile(
            title: 'LED Light',
            subtitle: 'Flash LED for notifications',
            value: _ledEnabled,
            onChanged: (value) => setState(() => _ledEnabled = value),
            icon: Icons.lightbulb,
          ),
        ],
      ],
    );
  }

  Widget _buildMessageNotificationsSection() {
    return _buildNotificationSection(
      title: 'Messages',
      icon: Icons.chat,
      color: AppColors.explorer,
      description: 'Get notified about new messages and conversations',
      children: [
        _buildSwitchTile(
          title: 'New Messages',
          subtitle: 'Notify when you receive new messages',
          value: _newMessagesEnabled,
          onChanged: (value) => setState(() => _newMessagesEnabled = value),
          icon: Icons.message,
        ),
        _buildSwitchTile(
          title: 'Message Replies',
          subtitle: 'Notify when someone replies to your messages',
          value: _messageRepliesEnabled,
          onChanged: (value) => setState(() => _messageRepliesEnabled = value),
          icon: Icons.reply,
        ),
        _buildSwitchTile(
          title: 'Group Messages',
          subtitle: 'Notify about group conversation activity',
          value: _groupMessagesEnabled,
          onChanged: (value) => setState(() => _groupMessagesEnabled = value),
          icon: Icons.group,
        ),
        _buildSwitchTile(
          title: 'Message Preview',
          subtitle: 'Show message content in notifications',
          value: _messagePreviewEnabled,
          onChanged: (value) => setState(() => _messagePreviewEnabled = value),
          icon: Icons.preview,
        ),
      ],
    );
  }

  Widget _buildMatchingDiscoverySection() {
    return _buildNotificationSection(
      title: 'Matching & Discovery',
      icon: Icons.favorite,
      color: AppColors.diplomat,
      description: 'Stay updated on matches and profile interactions',
      children: [
        _buildSwitchTile(
          title: 'New Matches',
          subtitle: 'Notify when you get a new match',
          value: _newMatchesEnabled,
          onChanged: (value) => setState(() => _newMatchesEnabled = value),
          icon: Icons.favorite,
        ),
        _buildSwitchTile(
          title: 'Profile Likes',
          subtitle: 'Notify when someone likes your profile',
          value: _likedProfileEnabled,
          onChanged: (value) => setState(() => _likedProfileEnabled = value),
          icon: Icons.thumb_up,
        ),
        _buildSwitchTile(
          title: 'Profile Views',
          subtitle: 'Notify when someone views your profile',
          value: _profileViewsEnabled,
          onChanged: (value) => setState(() => _profileViewsEnabled = value),
          icon: Icons.visibility,
        ),
        _buildSwitchTile(
          title: 'Super Likes',
          subtitle: 'Notify when you receive super likes',
          value: _superLikesEnabled,
          onChanged: (value) => setState(() => _superLikesEnabled = value),
          icon: Icons.star,
        ),
      ],
    );
  }

  Widget _buildSocialNotificationsSection() {
    return _buildNotificationSection(
      title: 'Social Activity',
      icon: Icons.people,
      color: AppColors.explorer,
      description: 'Notifications about friends and social interactions',
      children: [
        _buildSwitchTile(
          title: 'Friend Requests',
          subtitle: 'Notify when you receive friend requests',
          value: _friendRequestsEnabled,
          onChanged: (value) => setState(() => _friendRequestsEnabled = value),
          icon: Icons.person_add,
        ),
        _buildSwitchTile(
          title: 'Friend Accepted',
          subtitle: 'Notify when someone accepts your friend request',
          value: _friendAcceptedEnabled,
          onChanged: (value) => setState(() => _friendAcceptedEnabled = value),
          icon: Icons.check_circle,
        ),
        _buildSwitchTile(
          title: 'Comments',
          subtitle: 'Notify about comments on your posts',
          value: _commentsEnabled,
          onChanged: (value) => setState(() => _commentsEnabled = value),
          icon: Icons.comment,
        ),
        _buildSwitchTile(
          title: 'Likes on Posts',
          subtitle: 'Notify when someone likes your posts',
          value: _likesEnabled,
          onChanged: (value) => setState(() => _likesEnabled = value),
          icon: Icons.favorite_border,
        ),
        _buildSwitchTile(
          title: 'Shares',
          subtitle: 'Notify when someone shares your content',
          value: _sharesEnabled,
          onChanged: (value) => setState(() => _sharesEnabled = value),
          icon: Icons.share,
        ),
      ],
    );
  }

  Widget _buildMBTIAssessmentSection() {
    return _buildNotificationSection(
      title: 'MBTI & Assessments',
      icon: Icons.psychology,
      color: AppColors.analyst,
      description: 'Notifications about personality insights and assessments',
      children: [
        _buildSwitchTile(
          title: 'Assessment Reminders',
          subtitle: 'Remind you to complete personality assessments',
          value: _assessmentRemindersEnabled,
          onChanged:
              (value) => setState(() => _assessmentRemindersEnabled = value),
          icon: Icons.quiz,
        ),
        _buildSwitchTile(
          title: 'Personality Insights',
          subtitle: 'New insights about your MBTI type',
          value: _personalityInsightsEnabled,
          onChanged:
              (value) => setState(() => _personalityInsightsEnabled = value),
          icon: Icons.lightbulb_outline,
        ),
        _buildSwitchTile(
          title: 'Compatibility Updates',
          subtitle: 'Updates about compatibility with matches',
          value: _compatibilityUpdatesEnabled,
          onChanged:
              (value) => setState(() => _compatibilityUpdatesEnabled = value),
          icon: Icons.connect_without_contact,
        ),
        _buildSwitchTile(
          title: 'MBTI News',
          subtitle: 'Latest news and research about personality types',
          value: _mbtiNewsEnabled,
          onChanged: (value) => setState(() => _mbtiNewsEnabled = value),
          icon: Icons.newspaper,
        ),
      ],
    );
  }

  Widget _buildSystemNotificationsSection() {
    return _buildNotificationSection(
      title: 'System & Security',
      icon: Icons.security,
      color: AppColors.sentinel,
      description: 'Important system and security notifications',
      children: [
        _buildSwitchTile(
          title: 'Security Alerts',
          subtitle: 'Important security notifications',
          value: _securityAlertsEnabled,
          onChanged: (value) => setState(() => _securityAlertsEnabled = value),
          icon: Icons.security,
        ),
        _buildSwitchTile(
          title: 'Account Updates',
          subtitle: 'Changes to your account settings',
          value: _accountUpdatesEnabled,
          onChanged: (value) => setState(() => _accountUpdatesEnabled = value),
          icon: Icons.account_circle,
        ),
        _buildSwitchTile(
          title: 'App Updates',
          subtitle: 'Notify about new app versions',
          value: _appUpdatesEnabled,
          onChanged: (value) => setState(() => _appUpdatesEnabled = value),
          icon: Icons.system_update,
        ),
        _buildSwitchTile(
          title: 'Maintenance Notices',
          subtitle: 'Scheduled maintenance and downtime',
          value: _maintenanceNoticesEnabled,
          onChanged:
              (value) => setState(() => _maintenanceNoticesEnabled = value),
          icon: Icons.build,
        ),
      ],
    );
  }

  Widget _buildQuietHoursSection() {
    return _buildNotificationSection(
      title: 'Quiet Hours',
      icon: Icons.bedtime,
      color: AppColors.primary,
      description: 'Set times when notifications should be silent',
      children: [
        _buildSwitchTile(
          title: 'Enable Quiet Hours',
          subtitle: 'Silence notifications during specified hours',
          value: _quietHoursEnabled,
          onChanged: (value) => setState(() => _quietHoursEnabled = value),
          icon: Icons.do_not_disturb,
        ),
        if (_quietHoursEnabled) ...[
          _buildTimeTile(
            title: 'Start Time',
            subtitle: 'When quiet hours begin',
            time: _quietHoursStart,
            onChanged: (time) => setState(() => _quietHoursStart = time),
            icon: Icons.bedtime,
          ),
          _buildTimeTile(
            title: 'End Time',
            subtitle: 'When quiet hours end',
            time: _quietHoursEnd,
            onChanged: (time) => setState(() => _quietHoursEnd = time),
            icon: Icons.wb_sunny,
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationFrequencySection() {
    return _buildNotificationSection(
      title: 'Notification Frequency',
      icon: Icons.schedule,
      color: AppColors.diplomat,
      description: 'Control how often you receive notifications',
      children: [
        _buildDropdownTile(
          title: 'Push Notification Frequency',
          subtitle: 'How often to send push notifications',
          value: _pushFrequency,
          options: _frequencyOptions,
          onChanged: (value) => setState(() => _pushFrequency = value!),
          icon: Icons.phone_android,
        ),
        _buildDropdownTile(
          title: 'Email Frequency',
          subtitle: 'How often to send email notifications',
          value: _emailFrequency,
          options: _emailFrequencyOptions,
          onChanged: (value) => setState(() => _emailFrequency = value!),
          icon: Icons.email,
        ),
      ],
    );
  }

  Widget _buildNotificationSection({
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
      trailing: Switch(
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

  Widget _buildTimeTile({
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onChanged,
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
      trailing: GestureDetector(
        onTap: () => _selectTime(time, onChanged),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Text(
            time.format(context),
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  // Notification Service Methods
  void _testNotification() {
    _showLocalNotification(
      title: 'Test Notification',
      body: 'This is a test notification from MBTI Explorer! 🎉',
      type: NotificationType.test,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Test notification sent!',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _openDemoScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NotificationDemoScreen()),
    );
  }

  void _handlePushNotificationToggle(bool enabled) {
    if (enabled) {
      _requestNotificationPermissions();
    } else {
      _disableNotifications();
    }
  }

  void _requestNotificationPermissions() {
    // Simulate requesting notification permissions
    print('📱 Requesting notification permissions...');

    // In a real app, you would use a package like flutter_local_notifications
    // or firebase_messaging to request permissions

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Notification permissions requested',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _disableNotifications() {
    print('📱 Disabling notifications...');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Notifications disabled',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  void _playNotificationSound(String sound) {
    print('🔊 Playing notification sound: $sound');

    // In a real app, you would use a package like audioplayers
    // to play the selected sound

    if (sound != 'Silent') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Playing sound: $sound',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textInverse,
              letterSpacing: 0.3,
            ),
          ),
          backgroundColor: AppColors.info,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _testVibration() {
    print('📳 Testing vibration...');

    // In a real app, you would use a package like vibration
    // to trigger device vibration

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vibration test (simulated)',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.info,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _selectTime(
    TimeOfDay currentTime,
    ValueChanged<TimeOfDay> onChanged,
  ) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      onChanged(selectedTime);
    }
  }

  // Dummy notification service methods
  void _showLocalNotification({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    print('📱 Local Notification:');
    print('   Title: $title');
    print('   Body: $body');
    print('   Type: ${type.name}');
    print('   Data: $data');

    // In a real app, this would show an actual notification
    // using flutter_local_notifications or similar package
  }

  // Simulate different types of notifications
  void sendNewMessageNotification({
    required String senderName,
    required String message,
    required String conversationId,
  }) {
    if (!_newMessagesEnabled || !_pushNotificationsEnabled) return;

    _showLocalNotification(
      title: 'New message from $senderName',
      body: _messagePreviewEnabled ? message : 'You have a new message',
      type: NotificationType.message,
      data: {'conversationId': conversationId, 'senderName': senderName},
    );
  }

  void sendNewMatchNotification({
    required String matchName,
    required String matchId,
  }) {
    if (!_newMatchesEnabled || !_pushNotificationsEnabled) return;

    _showLocalNotification(
      title: 'New Match! 💕',
      body: 'You matched with $matchName',
      type: NotificationType.match,
      data: {'matchId': matchId, 'matchName': matchName},
    );
  }

  void sendPersonalityInsightNotification({
    required String insight,
    required String mbtiType,
  }) {
    if (!_personalityInsightsEnabled || !_pushNotificationsEnabled) return;

    _showLocalNotification(
      title: 'New MBTI Insight for $mbtiType',
      body: insight,
      type: NotificationType.mbtiInsight,
      data: {'mbtiType': mbtiType, 'insight': insight},
    );
  }

  void sendAssessmentReminderNotification() {
    if (!_assessmentRemindersEnabled || !_pushNotificationsEnabled) return;

    _showLocalNotification(
      title: 'Time for your personality check-in! 🧠',
      body: 'Complete a quick assessment to update your MBTI insights',
      type: NotificationType.assessmentReminder,
      data: {},
    );
  }

  void sendSecurityAlertNotification({
    required String alertMessage,
    required String alertType,
  }) {
    if (!_securityAlertsEnabled || !_pushNotificationsEnabled) return;

    _showLocalNotification(
      title: 'Security Alert 🔒',
      body: alertMessage,
      type: NotificationType.security,
      data: {'alertType': alertType},
    );
  }
}

enum NotificationType {
  test,
  message,
  match,
  mbtiInsight,
  assessmentReminder,
  security,
  social,
  system,
}
