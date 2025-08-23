import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Service for handling local and push notifications
/// This is a dummy implementation that simulates real notification functionality
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;
  bool _permissionsGranted = false;
  NotificationSettings _settings = NotificationSettings();

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Simulate initialization delay
      await Future.delayed(const Duration(milliseconds: 500));

      // In a real app, you would initialize flutter_local_notifications here
      debugPrint('🔔 NotificationService: Initializing...');

      _isInitialized = true;
      debugPrint('🔔 NotificationService: Initialized successfully');
    } catch (e) {
      debugPrint('🔔 NotificationService: Initialization failed: $e');
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await initialize();

    try {
      // Simulate permission request
      debugPrint('🔔 NotificationService: Requesting permissions...');
      await Future.delayed(const Duration(milliseconds: 1000));

      // In a real app, you would request actual permissions here
      _permissionsGranted = true;
      debugPrint('🔔 NotificationService: Permissions granted');

      return true;
    } catch (e) {
      debugPrint('🔔 NotificationService: Permission request failed: $e');
      return false;
    }
  }

  /// Update notification settings
  void updateSettings(NotificationSettings settings) {
    _settings = settings;
    debugPrint('🔔 NotificationService: Settings updated');
    debugPrint('   Push enabled: ${settings.pushEnabled}');
    debugPrint('   Sound enabled: ${settings.soundEnabled}');
    debugPrint('   Vibration enabled: ${settings.vibrationEnabled}');
  }

  /// Show a local notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.defaultPriority,
    String? sound,
    bool? vibrate,
    bool? lights,
  }) async {
    if (!_isInitialized || !_permissionsGranted || !_settings.pushEnabled) {
      debugPrint(
        '🔔 NotificationService: Cannot show notification - service not ready or disabled',
      );
      return;
    }

    try {
      // Simulate showing notification
      debugPrint('🔔 NotificationService: Showing notification');
      debugPrint('   ID: $id');
      debugPrint('   Title: $title');
      debugPrint('   Body: $body');
      debugPrint('   Priority: ${priority.name}');

      // Simulate sound
      if (_settings.soundEnabled && sound != null && sound != 'Silent') {
        debugPrint('🔊 Playing notification sound: $sound');
        await _playSound(sound);
      }

      // Simulate vibration
      if (_settings.vibrationEnabled && (vibrate ?? true)) {
        debugPrint('📳 Triggering vibration');
        await _triggerVibration();
      }

      // Simulate LED
      if (_settings.ledEnabled && (lights ?? false)) {
        debugPrint('💡 Triggering LED notification');
        await _triggerLED();
      }

      // In a real app, you would show the actual notification here
      // using flutter_local_notifications plugin
    } catch (e) {
      debugPrint('🔔 NotificationService: Failed to show notification: $e');
    }
  }

  /// Schedule a notification for later
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationPriority priority = NotificationPriority.defaultPriority,
  }) async {
    if (!_isInitialized || !_permissionsGranted || !_settings.pushEnabled) {
      debugPrint(
        '🔔 NotificationService: Cannot schedule notification - service not ready or disabled',
      );
      return;
    }

    try {
      debugPrint('🔔 NotificationService: Scheduling notification');
      debugPrint('   ID: $id');
      debugPrint('   Title: $title');
      debugPrint('   Scheduled for: $scheduledDate');

      // In a real app, you would schedule the notification here
      // using flutter_local_notifications plugin
    } catch (e) {
      debugPrint('🔔 NotificationService: Failed to schedule notification: $e');
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    debugPrint('🔔 NotificationService: Cancelling notification $id');

    // In a real app, you would cancel the notification here
    // using flutter_local_notifications plugin
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    debugPrint('🔔 NotificationService: Cancelling all notifications');

    // In a real app, you would cancel all notifications here
    // using flutter_local_notifications plugin
  }

  /// Get pending notifications
  Future<List<PendingNotification>> getPendingNotifications() async {
    debugPrint('🔔 NotificationService: Getting pending notifications');

    // In a real app, you would return actual pending notifications
    return [];
  }

  /// Check if notifications are enabled
  bool get isEnabled =>
      _isInitialized && _permissionsGranted && _settings.pushEnabled;

  /// Check if in quiet hours
  bool get isInQuietHours {
    if (!_settings.quietHoursEnabled) return false;

    final now = TimeOfDay.now();
    final start = _settings.quietHoursStart;
    final end = _settings.quietHoursEnd;

    // Handle quiet hours that span midnight
    if (start.hour > end.hour) {
      return now.hour >= start.hour || now.hour < end.hour;
    } else {
      return now.hour >= start.hour && now.hour < end.hour;
    }
  }

  // MBTI-specific notification methods

  /// Send a new message notification
  Future<void> sendMessageNotification({
    required String senderName,
    required String senderAvatar,
    required String message,
    required String conversationId,
    String? mbtiType,
  }) async {
    if (isInQuietHours) {
      debugPrint('🔔 Skipping notification - in quiet hours');
      return;
    }

    await showNotification(
      id: conversationId.hashCode,
      title:
          'New message from $senderName ${mbtiType != null ? '($mbtiType)' : ''}',
      body:
          _settings.messagePreviewEnabled ? message : 'You have a new message',
      payload: 'message:$conversationId',
      priority: NotificationPriority.high,
      sound: _settings.notificationSound,
    );
  }

  /// Send a new match notification
  Future<void> sendMatchNotification({
    required String matchName,
    required String matchId,
    required String mbtiType,
    int? compatibilityScore,
  }) async {
    if (isInQuietHours) return;

    await showNotification(
      id: matchId.hashCode,
      title: 'New Match! 💕',
      body:
          'You matched with $matchName ($mbtiType)${compatibilityScore != null ? ' - $compatibilityScore% compatible!' : ''}',
      payload: 'match:$matchId',
      priority: NotificationPriority.high,
      sound: _settings.notificationSound,
      vibrate: true,
    );
  }

  /// Send MBTI personality insight notification
  Future<void> sendPersonalityInsightNotification({
    required String insight,
    required String mbtiType,
  }) async {
    if (isInQuietHours) return;

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'New MBTI Insight for $mbtiType 🧠',
      body: insight,
      payload: 'insight:$mbtiType',
      priority: NotificationPriority.defaultPriority,
      sound: _settings.notificationSound,
    );
  }

  /// Send assessment reminder notification
  Future<void> sendAssessmentReminderNotification() async {
    if (isInQuietHours) return;

    await showNotification(
      id: 999999, // Fixed ID for assessment reminders
      title: 'Time for your personality check-in! 🧠',
      body: 'Complete a quick assessment to update your MBTI insights',
      payload: 'assessment:reminder',
      priority: NotificationPriority.defaultPriority,
      sound: _settings.notificationSound,
    );
  }

  /// Send security alert notification
  Future<void> sendSecurityAlertNotification({
    required String alertMessage,
    required String alertType,
  }) async {
    // Security alerts ignore quiet hours
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Security Alert 🔒',
      body: alertMessage,
      payload: 'security:$alertType',
      priority: NotificationPriority.max,
      sound: 'Default', // Always use default sound for security
      vibrate: true,
    );
  }

  /// Send friend request notification
  Future<void> sendFriendRequestNotification({
    required String requesterName,
    required String requesterId,
    required String mbtiType,
  }) async {
    if (isInQuietHours) return;

    await showNotification(
      id: requesterId.hashCode,
      title: 'Friend Request 👥',
      body: '$requesterName ($mbtiType) wants to be friends',
      payload: 'friend_request:$requesterId',
      priority: NotificationPriority.defaultPriority,
      sound: _settings.notificationSound,
    );
  }

  /// Send profile like notification
  Future<void> sendProfileLikeNotification({
    required String likerName,
    required String likerId,
    required String mbtiType,
  }) async {
    if (isInQuietHours) return;

    await showNotification(
      id: likerId.hashCode,
      title: 'Someone likes your profile! 👍',
      body: '$likerName ($mbtiType) liked your profile',
      payload: 'profile_like:$likerId',
      priority: NotificationPriority.low,
      sound: _settings.notificationSound,
    );
  }

  // Private helper methods

  Future<void> _playSound(String sound) async {
    try {
      // Simulate sound playing
      await Future.delayed(const Duration(milliseconds: 100));

      // In a real app, you would use audioplayers or similar
      // to play the actual sound file
    } catch (e) {
      debugPrint('🔊 Failed to play sound: $e');
    }
  }

  Future<void> _triggerVibration() async {
    try {
      // Simulate vibration
      await Future.delayed(const Duration(milliseconds: 50));

      // In a real app, you would use the vibration plugin
      // Vibration.vibrate(duration: 500);
    } catch (e) {
      debugPrint('📳 Failed to trigger vibration: $e');
    }
  }

  Future<void> _triggerLED() async {
    try {
      // Simulate LED notification
      await Future.delayed(const Duration(milliseconds: 10));

      // In a real app, this would be handled by the notification plugin
      // as LED notifications are typically system-controlled
    } catch (e) {
      debugPrint('💡 Failed to trigger LED: $e');
    }
  }
}

/// Notification settings model
class NotificationSettings {
  final bool pushEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool ledEnabled;
  final String notificationSound;
  final bool messagePreviewEnabled;
  final bool quietHoursEnabled;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;

  NotificationSettings({
    this.pushEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.ledEnabled = false,
    this.notificationSound = 'Default',
    this.messagePreviewEnabled = false,
    this.quietHoursEnabled = false,
    this.quietHoursStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietHoursEnd = const TimeOfDay(hour: 8, minute: 0),
  });

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? ledEnabled,
    String? notificationSound,
    bool? messagePreviewEnabled,
    bool? quietHoursEnabled,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      ledEnabled: ledEnabled ?? this.ledEnabled,
      notificationSound: notificationSound ?? this.notificationSound,
      messagePreviewEnabled:
          messagePreviewEnabled ?? this.messagePreviewEnabled,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}

/// Notification priority levels
enum NotificationPriority { min, low, defaultPriority, high, max }

/// Pending notification model
class PendingNotification {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledDate;
  final String? payload;

  PendingNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDate,
    this.payload,
  });
}

/// Time of day extension for comparison
extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay now() {
    final now = DateTime.now();
    return TimeOfDay(hour: now.hour, minute: now.minute);
  }
}
