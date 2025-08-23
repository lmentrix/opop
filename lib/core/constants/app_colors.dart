import 'package:flutter/material.dart';

/// MBTI-themed color palette designed for teen users
/// Features vibrant, energetic colors that represent different personality types
class AppColors {
  // Primary Brand Colors - Energetic and engaging
  static const Color primary = Color(0xFF6366F1); // Indigo - Main brand color
  static const Color primaryLight = Color(0xFF818CF8); // Lighter indigo
  static const Color primaryDark = Color(0xFF4F46E5); // Darker indigo

  // Secondary Colors - Fun and interactive
  static const Color secondary = Color(0xFFEC4899); // Pink - Secondary brand
  static const Color accent = Color(0xFF10B981); // Emerald - Accent color

  // MBTI Personality Type Colors
  static const Color analyst = Color(
    0xFF8B5CF6,
  ); // Purple - INTJ, INTP, ENTJ, ENTP
  static const Color diplomat = Color(
    0xFF06B6D4,
  ); // Cyan - INFJ, INFP, ENFJ, ENFP
  static const Color sentinel = Color(
    0xFF059669,
  ); // Green - ISTJ, ISFJ, ESTJ, ESFJ
  static const Color explorer = Color(
    0xFFF59E0B,
  ); // Amber - ISTP, ISFP, ESTP, ESFP

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Emerald green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937); // Dark gray
  static const Color textSecondary = Color(0xFF6B7280); // Medium gray
  static const Color textDisabled = Color(0xFF9CA3AF); // Light gray
  static const Color textInverse = Color(0xFFFFFFFF); // White

  // Background Colors
  static const Color background = Color(0xFFF9FAFB); // Light gray background
  static const Color surface = Color(0xFFFFFFFF); // White surface
  static const Color surfaceVariant = Color(
    0xFFF3F4F6,
  ); // Slightly darker surface

  // Interactive Element Colors
  static const Color divider = Color(0xFFE5E7EB); // Light gray divider
  static const Color outline = Color(0xFFD1D5DB); // Border color
  static const Color shadow = Color(0xFF000000); // Shadow color (with opacity)

  // Gradient Colors for Interactive Elements
  static const List<Color> primaryGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFEC4899),
    Color(0xFFF59E0B),
  ];

  static const List<Color> successGradient = [
    Color(0xFF10B981),
    Color(0xFF059669),
  ];

  // MBTI Type Specific Gradients
  static const List<Color> analystGradient = [
    Color(0xFF8B5CF6),
    Color(0xFF6366F1),
  ];

  static const List<Color> diplomatGradient = [
    Color(0xFF06B6D4),
    Color(0xFF0891B2),
  ];

  static const List<Color> sentinelGradient = [
    Color(0xFF059669),
    Color(0xFF047857),
  ];

  static const List<Color> explorerGradient = [
    Color(0xFFF59E0B),
    Color(0xFFD97706),
  ];

  // Interactive State Colors
  static const Color hover = Color(0xFFF3F4F6); // Hover state
  static const Color pressed = Color(0xFFE5E7EB); // Pressed state
  static const Color selected = Color(0xFFDBEAFE); // Selected state

  // Special Effect Colors
  static const Color glow = Color(0xFF6366F1); // Glow effect color
  static const Color shimmer = Color(0xFFF3F4F6); // Shimmer effect color
}
