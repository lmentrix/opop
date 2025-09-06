import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

/// Dark theme configuration for MBTI Explorer
/// Features darker colors while maintaining the vibrant MBTI personality
class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      // Brightness
      brightness: Brightness.dark,

      // Color scheme - Darker variants
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.textInverse,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textInverse,
        tertiary: AppColors.accent,
        onTertiary: AppColors.textInverse,
        error: AppColors.error,
        onError: AppColors.textInverse,
        surface: Color(0xFF1E1E1E), // Dark surface
        onSurface: AppColors.textInverse,
        surfaceContainerHighest: Color(0xFF2D2D2D), // Darker surface variant
        onSurfaceVariant: AppColors.textInverse,
        outline: Color(0xFF404040), // Darker outline
        outlineVariant: Color(0xFF2D2D2D), // Darker divider
        shadow: AppColors.shadow,
        scrim: AppColors.shadow,
        inverseSurface: AppColors.textInverse,
        onInverseSurface: Color(0xFF1E1E1E),
        inversePrimary: AppColors.primaryLight,
        surfaceTint: AppColors.primary,
      ),

      // Text theme with dark colors
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: AppColors.textInverse,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: AppColors.textInverse,
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: AppColors.textInverse,
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: AppColors.textInverse,
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: AppColors.textInverse,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: AppColors.textInverse,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: AppColors.textInverse,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppColors.textInverse,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(
          color: AppColors.textInverse,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: AppColors.textInverse,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: AppColors.textInverse,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: AppColors.textInverse,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          color: AppColors.textInverse,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: AppColors.textInverse,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: AppColors.textInverse,
        ),
      ),

      // Primary text theme
      primaryTextTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: AppColors.primary,
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: AppColors.primary,
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: AppColors.primary,
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: AppColors.primary,
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: AppColors.primary,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: AppColors.primary,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(color: AppColors.primary),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: AppColors.primary,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(color: AppColors.primary),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.primary),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
        bodySmall: AppTypography.bodySmall.copyWith(color: AppColors.primary),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.primary),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: AppColors.primary,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(color: AppColors.primary),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: AppColors.textInverse,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textInverse,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(
          color: AppColors.textInverse,
          size: AppSpacing.iconSize,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.textInverse,
          size: AppSpacing.iconSize,
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: const Color(0xFF2D2D2D),
        elevation: 4,
        shadowColor: AppColors.shadow.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          elevation: 4,
          shadowColor: AppColors.shadow.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: AppTypography.buttonText,
          minimumSize: const Size(0, AppSpacing.xl * 1.5),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: AppTypography.buttonText.copyWith(
            color: AppColors.primary,
          ),
          minimumSize: const Size(0, AppSpacing.xl * 1.5),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonText.copyWith(
            color: AppColors.primary,
          ),
          minimumSize: const Size(0, AppSpacing.xl),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: const BorderSide(color: Color(0xFF404040)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textInverse.withOpacity(0.7),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textInverse.withOpacity(0.5),
        ),
        errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2D2D2D),
        selectedColor: AppColors.primary,
        disabledColor: AppColors.textDisabled,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textInverse,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.full),
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(0xFF404040),
        thickness: 1,
        space: AppSpacing.md,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: AppColors.textInverse,
        size: AppSpacing.iconSize,
      ),

      // Primary icon theme
      primaryIconTheme: const IconThemeData(
        color: AppColors.primary,
        size: AppSpacing.iconSize,
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textInverse,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textInverse.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      ),

      // Tab bar theme
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textInverse.withOpacity(0.6),
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textInverse,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textInverse,
        ),
      ),

      // Snack bar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textInverse,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress indicator theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: Color(0xFF2D2D2D),
        circularTrackColor: Color(0xFF2D2D2D),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withOpacity(0.5);
          }
          return const Color(0xFF2D2D2D);
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textInverse),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
        ),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textInverse.withOpacity(0.6);
        }),
      ),

      // Slider theme
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: const Color(0xFF2D2D2D),
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withOpacity(0.2),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textInverse,
        ),
      ),

      // Page transitions theme
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
