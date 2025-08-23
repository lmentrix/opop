import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/notification_service.dart';

/// Demo screen to test different types of notifications
class NotificationDemoScreen extends StatefulWidget {
  const NotificationDemoScreen({super.key});

  @override
  State<NotificationDemoScreen> createState() => _NotificationDemoScreenState();
}

class _NotificationDemoScreenState extends State<NotificationDemoScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    await _notificationService.requestPermissions();

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDemoOverview(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildNotificationTests(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildServiceStatus(),
                  ],
                ),
              ),
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
              'Notification Demo',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildDemoOverview() {
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
            Icons.science,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize * 2,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Notification Testing Lab',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Test different notification types to see how they work on your device. This is a demo environment with simulated notifications.',
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

  Widget _buildNotificationTests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Test Notifications',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Tap any button below to simulate receiving that type of notification.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildTestButton(
          title: 'New Message',
          subtitle: 'Simulate receiving a new message',
          icon: Icons.message,
          color: AppColors.explorer,
          onTap: _testMessageNotification,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTestButton(
          title: 'New Match',
          subtitle: 'Simulate getting a new match',
          icon: Icons.favorite,
          color: AppColors.diplomat,
          onTap: _testMatchNotification,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTestButton(
          title: 'MBTI Insight',
          subtitle: 'Simulate personality insight notification',
          icon: Icons.psychology,
          color: AppColors.analyst,
          onTap: _testInsightNotification,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTestButton(
          title: 'Assessment Reminder',
          subtitle: 'Simulate assessment reminder',
          icon: Icons.quiz,
          color: AppColors.primary,
          onTap: _testAssessmentReminder,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTestButton(
          title: 'Friend Request',
          subtitle: 'Simulate friend request notification',
          icon: Icons.person_add,
          color: AppColors.explorer,
          onTap: _testFriendRequestNotification,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTestButton(
          title: 'Security Alert',
          subtitle: 'Simulate security alert (high priority)',
          icon: Icons.security,
          color: AppColors.error,
          onTap: _testSecurityAlert,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildTestButton(
          title: 'Profile Like',
          subtitle: 'Simulate someone liking your profile',
          icon: Icons.thumb_up,
          color: AppColors.success,
          onTap: _testProfileLike,
        ),
      ],
    );
  }

  Widget _buildServiceStatus() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(
          color:
              _isInitialized
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.warning.withOpacity(0.3),
        ),
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
                  color: (_isInitialized
                          ? AppColors.success
                          : AppColors.warning)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Icon(
                  _isInitialized ? Icons.check_circle : Icons.warning,
                  color: _isInitialized ? AppColors.success : AppColors.warning,
                  size: AppSpacing.iconSize,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification Service Status',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      _isInitialized ? 'Service is ready' : 'Initializing...',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildStatusRow('Initialized', _isInitialized),
          _buildStatusRow('Permissions Granted', _isInitialized),
          _buildStatusRow('Service Enabled', _notificationService.isEnabled),
          _buildStatusRow(
            'In Quiet Hours',
            _notificationService.isInQuietHours,
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton({
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
          Icons.play_arrow,
          color: color,
          size: AppSpacing.iconSize,
        ),
        onTap: _isInitialized ? onTap : null,
      ),
    );
  }

  Widget _buildStatusRow(String label, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            color: status ? AppColors.success : AppColors.error,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          Text(
            status ? 'Yes' : 'No',
            style: AppTypography.bodySmall.copyWith(
              color: status ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // Test notification methods

  void _testMessageNotification() {
    _notificationService.sendMessageNotification(
      senderName: 'Alex Chen',
      senderAvatar: '👩‍💻',
      message:
          'Hey! I saw you\'re also an INTJ. Want to discuss our shared love for strategic thinking? 🧠',
      conversationId: 'conv_123',
      mbtiType: 'INTJ',
    );

    _showTestConfirmation('Message notification sent!');
  }

  void _testMatchNotification() {
    _notificationService.sendMatchNotification(
      matchName: 'Sarah Martinez',
      matchId: 'match_456',
      mbtiType: 'ENFP',
      compatibilityScore: 92,
    );

    _showTestConfirmation('Match notification sent!');
  }

  void _testInsightNotification() {
    _notificationService.sendPersonalityInsightNotification(
      insight:
          'INTJs are natural system builders. Today\'s tip: Try breaking down complex problems into smaller, manageable components to leverage your strategic thinking.',
      mbtiType: 'INTJ',
    );

    _showTestConfirmation('Personality insight notification sent!');
  }

  void _testAssessmentReminder() {
    _notificationService.sendAssessmentReminderNotification();

    _showTestConfirmation('Assessment reminder sent!');
  }

  void _testFriendRequestNotification() {
    _notificationService.sendFriendRequestNotification(
      requesterName: 'Jordan Kim',
      requesterId: 'user_789',
      mbtiType: 'ENTP',
    );

    _showTestConfirmation('Friend request notification sent!');
  }

  void _testSecurityAlert() {
    _notificationService.sendSecurityAlertNotification(
      alertMessage: 'New login detected from iPhone in San Francisco, CA',
      alertType: 'new_login',
    );

    _showTestConfirmation('Security alert sent!');
  }

  void _testProfileLike() {
    _notificationService.sendProfileLikeNotification(
      likerName: 'Emma Davis',
      likerId: 'user_101',
      mbtiType: 'ISFP',
    );

    _showTestConfirmation('Profile like notification sent!');
  }

  void _showTestConfirmation(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
      ),
    );
  }
}
