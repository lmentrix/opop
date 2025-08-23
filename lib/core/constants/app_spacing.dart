/// MBTI app spacing system designed for teen users
/// Features consistent spacing that creates comfortable, engaging layouts
class AppSpacing {
  // Base unit: 4px for fine control
  static const double xs = 4.0; // 0.5x - Minimal spacing
  static const double sm = 8.0; // 1x - Small spacing
  static const double md = 16.0; // 2x - Medium spacing
  static const double lg = 24.0; // 3x - Large spacing
  static const double xl = 32.0; // 4x - Extra large spacing
  static const double xxl = 48.0; // 6x - Double extra large
  static const double xxxl = 64.0; // 8x - Triple extra large

  // Component specific spacing
  static const double cardPadding = 16.0; // Card internal padding
  static const double screenPadding = 20.0; // Screen edge padding
  static const double listItemSpacing = 12.0; // Space between list items
  static const double sectionSpacing = 32.0; // Space between sections

  // Interactive element spacing
  static const double buttonPadding = 16.0; // Button internal padding
  static const double inputPadding = 16.0; // Input field padding
  static const double iconSize = 24.0; // Default icon size
  static const double iconPadding = 8.0; // Icon spacing
  static const double avatarSpacing = 12.0; // Avatar spacing

  // Form and layout spacing
  static const double formSpacing = 24.0; // Space between form elements
  static const double fieldSpacing = 16.0; // Space between form fields
  static const double groupSpacing = 32.0; // Space between form groups

  // Navigation and header spacing
  static const double appBarHeight = 56.0; // App bar height
  static const double bottomNavHeight = 80.0; // Bottom navigation height
  static const double tabHeight = 48.0; // Tab height

  // Content spacing
  static const double contentPadding = 20.0; // Main content padding
  static const double paragraphSpacing = 16.0; // Space between paragraphs
  static const double headingSpacing = 24.0; // Space after headings

  // Interactive feedback spacing
  static const double rippleRadius = 20.0; // Ripple effect radius
  static const double touchTarget = 48.0; // Minimum touch target size
  static const double focusRing = 4.0; // Focus ring thickness

  // Animation and transition spacing
  static const double slideDistance = 20.0; // Slide animation distance
  static const double scaleFactor = 0.95; // Press scale factor
  static const double elevation = 4.0; // Default elevation

  // Border radius constants
  static const double full = 999.0; // Full rounded corners

  // MBTI specific spacing
  static const double personalityCardSpacing = 16.0; // Personality type cards
  static const double questionSpacing = 24.0; // Space between questions
  static const double answerOptionSpacing =
      12.0; // Space between answer options
  static const double resultSpacing = 32.0; // Space in results section
}
