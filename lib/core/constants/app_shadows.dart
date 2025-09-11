import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Comprehensive shadow system for enhanced visual hierarchy and depth
/// Provides consistent shadows across the app with varying elevations
class AppShadows {
  // Base shadow colors
  static final Color _primaryShadow = AppColors.shadow.withOpacity(0.1);
  static final Color _secondaryShadow = AppColors.shadow.withOpacity(0.05);
  static final Color _accentShadow = AppColors.primary.withOpacity(0.1);

  // Elevation levels based on Material Design specifications
  static const double _elevation1 = 1.0;
  static const double _elevation2 = 2.0;
  static const double _elevation4 = 4.0;
  static const double _elevation6 = 6.0;
  static const double _elevation8 = 8.0;
  static const double _elevation12 = 12.0;
  static const double _elevation16 = 16.0;
  static const double _elevation24 = 24.0;

  /// Subtle shadow for low elevation elements (1dp)
  /// Perfect for: Cards at rest, list items, chips
  static final List<BoxShadow> subtle = [
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 2,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  /// Soft shadow for slightly elevated elements (2dp)
  /// Perfect for: Buttons, search bars, input fields
  static final List<BoxShadow> soft = [
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _secondaryShadow,
      blurRadius: 2,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow for interactive elements (4dp)
  /// Perfect for: Elevated buttons, floating action buttons, app bars
  static final List<BoxShadow> medium = [
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 6,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _secondaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Strong shadow for prominent elements (6dp)
  /// Perfect for: Navigation drawers, dialogs, snack bars
  static final List<BoxShadow> strong = [
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _secondaryShadow,
      blurRadius: 6,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Heavy shadow for highly elevated elements (8dp)
  /// Perfect for: Modal bottom sheets, navigation rails
  static final List<BoxShadow> heavy = [
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 10,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _secondaryShadow,
      blurRadius: 8,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Dramatic shadow for maximum elevation (12dp+)
  /// Perfect for: Full-screen dialogs, tooltips, menus
  static final List<BoxShadow> dramatic = [
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 16,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _secondaryShadow,
      blurRadius: 12,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  // Specialized shadows for specific use cases

  /// Accent shadow with brand color tint
  /// Perfect for: Primary actions, featured content, highlights
  static final List<BoxShadow> accent = [
    BoxShadow(
      color: _accentShadow,
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Inner shadow effect for pressed/inset elements
  /// Perfect for: Active buttons, selected states, input focus
  static final List<BoxShadow> inner = [
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  /// Glow effect for special emphasis
  /// Perfect for: Notifications, alerts, special actions
  static final List<BoxShadow> glow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 0),
      spreadRadius: 2,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 6,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
  ];

  /// Error shadow with red tint for error states
  /// Perfect for: Error messages, validation feedback, alerts
  static final List<BoxShadow> error = [
    BoxShadow(
      color: AppColors.error.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Success shadow with green tint for success states
  /// Perfect for: Success messages, confirmations, completed actions
  static final List<BoxShadow> success = [
    BoxShadow(
      color: AppColors.success.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Warning shadow with amber tint for warning states
  /// Perfect for: Warning messages, caution alerts, pending actions
  static final List<BoxShadow> warning = [
    BoxShadow(
      color: AppColors.warning.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // Personality type shadows for MBTI theming

  /// Analyst shadow with purple tint
  static final List<BoxShadow> analyst = [
    BoxShadow(
      color: AppColors.analyst.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Diplomat shadow with cyan tint
  static final List<BoxShadow> diplomat = [
    BoxShadow(
      color: AppColors.diplomat.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Sentinel shadow with green tint
  static final List<BoxShadow> sentinel = [
    BoxShadow(
      color: AppColors.sentinel.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  /// Explorer shadow with amber tint
  static final List<BoxShadow> explorer = [
    BoxShadow(
      color: AppColors.explorer.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: _primaryShadow,
      blurRadius: 4,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // Utility methods for custom shadows

  /// Creates a custom shadow with specified parameters
  static List<BoxShadow> custom({
    required Color color,
    double blurRadius = 8.0,
    Offset offset = const Offset(0, 3),
    double spreadRadius = 0.0,
    double opacity = 0.15,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: spreadRadius,
      ),
    ];
  }

  /// Creates a layered shadow with multiple depths
  static List<BoxShadow> layered({
    required Color primaryColor,
    required Color secondaryColor,
    double primaryBlur = 8.0,
    double secondaryBlur = 4.0,
    Offset primaryOffset = const Offset(0, 3),
    Offset secondaryOffset = const Offset(0, 6),
    double primaryOpacity = 0.15,
    double secondaryOpacity = 0.1,
  }) {
    return [
      BoxShadow(
        color: primaryColor.withOpacity(primaryOpacity),
        blurRadius: primaryBlur,
        offset: primaryOffset,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: secondaryColor.withOpacity(secondaryOpacity),
        blurRadius: secondaryBlur,
        offset: secondaryOffset,
        spreadRadius: 0,
      ),
    ];
  }

  /// No shadow - for flat design elements
  static const List<BoxShadow> none = [];
}
