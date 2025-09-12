import 'package:flutter/material.dart' show FontWeight, TextAlign;

/// Text story configuration data for MBTI Explorer app
/// Provides configuration options for text story creation
class TextStoryData {
  /// Available background colors for text stories
  static const List<String> backgroundColorHexCodes = [
    '#9C27B0', // analyst
    '#00BCD4', // diplomat
    '#4CAF50', // sentinel
    '#FFC107', // explorer
    '#2196F3', // primary
    '#F44336', // error
    '#FF9800', // warning
    '#4CAF50', // success
  ];

  /// Available font sizes for text stories
  static const List<double> fontSizes = [
    16.0,
    20.0,
    24.0,
    28.0,
    32.0,
    36.0,
    42.0,
  ];

  /// Available font weights for text stories
  static const List<String> fontWeightNames = [
    'normal',
    'medium',
    'bold',
    'extra bold',
  ];

  /// Available text alignment options for text stories
  static const List<String> textAlignments = ['left', 'center', 'right'];

  /// Default font size
  static const double defaultFontSize = 24.0;

  /// Default background color hex code
  static const String defaultBackgroundColorHex = '#9C27B0';

  /// Default text alignment
  static const String defaultTextAlignment = 'center';

  /// Default font weight
  static const String defaultFontWeight = 'normal';

  /// Get font weight from name
  static FontWeight getFontWeight(String name) {
    switch (name) {
      case 'normal':
        return FontWeight.normal;
      case 'medium':
        return FontWeight.w500;
      case 'bold':
        return FontWeight.bold;
      case 'extra bold':
        return FontWeight.w800;
      default:
        return FontWeight.normal;
    }
  }

  /// Get text alignment from name
  static TextAlign getTextAlign(String name) {
    switch (name) {
      case 'left':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.center;
    }
  }

  /// Get alignment icon for text alignment
  static String getAlignmentIcon(String alignment) {
    switch (alignment) {
      case 'left':
        return 'format_align_left';
      case 'center':
        return 'format_align_center';
      case 'right':
        return 'format_align_right';
      default:
        return 'format_align_center';
    }
  }
}
