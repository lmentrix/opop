import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/futuristic_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_typography.dart';

/// Futuristic theme configuration with cyber-tech aesthetic
/// Features neon colors, glowing effects, and sci-fi inspired design
class FuturisticTheme {
  static ThemeData get theme {
    return ThemeData(
      // Brightness
      brightness: Brightness.dark,

      // Color scheme - Futuristic cyber theme
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: FuturisticColors.primary,
        onPrimary: FuturisticColors.textInverse,
        secondary: FuturisticColors.secondary,
        onSecondary: FuturisticColors.textInverse,
        tertiary: FuturisticColors.accent,
        onTertiary: FuturisticColors.textInverse,
        error: FuturisticColors.error,
        onError: FuturisticColors.textInverse,
        surface: FuturisticColors.surface,
        onSurface: FuturisticColors.textPrimary,
        surfaceContainerHighest: FuturisticColors.surfaceVariant,
        onSurfaceVariant: FuturisticColors.textSecondary,
        outline: FuturisticColors.outline,
        outlineVariant: FuturisticColors.divider,
        shadow: FuturisticColors.shadow,
        scrim: FuturisticColors.shadow,
        inverseSurface: FuturisticColors.textPrimary,
        onInverseSurface: FuturisticColors.surface,
        inversePrimary: FuturisticColors.primaryLight,
        surfaceTint: FuturisticColors.primary,
      ),

      // Text theme with futuristic styling
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(
              color: FuturisticColors.glow.withOpacity(0.5),
              blurRadius: 10,
            ),
          ],
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: FuturisticColors.glow.withOpacity(0.3),
              blurRadius: 8,
            ),
          ],
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: FuturisticColors.glow.withOpacity(0.3),
              blurRadius: 6,
            ),
          ],
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: FuturisticColors.glow.withOpacity(0.2),
              blurRadius: 4,
            ),
          ],
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: FuturisticColors.textPrimary,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(
          color: FuturisticColors.textSecondary,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: FuturisticColors.textPrimary,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: FuturisticColors.textPrimary,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: FuturisticColors.textSecondary,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: FuturisticColors.textSecondary,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: FuturisticColors.textSecondary,
        ),
      ),

      // Primary text theme with glowing effects
      primaryTextTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          color: FuturisticColors.primary,
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(
              color: FuturisticColors.primary.withOpacity(0.5),
              blurRadius: 15,
            ),
          ],
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          color: FuturisticColors.primary,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: FuturisticColors.primary.withOpacity(0.4),
              blurRadius: 12,
            ),
          ],
        ),
        displaySmall: AppTypography.displaySmall.copyWith(
          color: FuturisticColors.primary,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: FuturisticColors.primary.withOpacity(0.3),
              blurRadius: 8,
            ),
          ],
        ),
        headlineLarge: AppTypography.headlineLarge.copyWith(
          color: FuturisticColors.primary,
          shadows: [
            Shadow(
              color: FuturisticColors.primary.withOpacity(0.3),
              blurRadius: 6,
            ),
          ],
        ),
        headlineMedium: AppTypography.headlineMedium.copyWith(
          color: FuturisticColors.primary,
        ),
        headlineSmall: AppTypography.headlineSmall.copyWith(
          color: FuturisticColors.primary,
        ),
        titleLarge: AppTypography.titleLarge.copyWith(
          color: FuturisticColors.primary,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: FuturisticColors.primary,
        ),
        titleSmall: AppTypography.titleSmall.copyWith(
          color: FuturisticColors.primary,
        ),
        bodyLarge: AppTypography.bodyLarge.copyWith(
          color: FuturisticColors.primary,
        ),
        bodyMedium: AppTypography.bodyMedium.copyWith(
          color: FuturisticColors.primary,
        ),
        bodySmall: AppTypography.bodySmall.copyWith(
          color: FuturisticColors.primary,
        ),
        labelLarge: AppTypography.labelLarge.copyWith(
          color: FuturisticColors.primary,
        ),
        labelMedium: AppTypography.labelMedium.copyWith(
          color: FuturisticColors.primary,
        ),
        labelSmall: AppTypography.labelSmall.copyWith(
          color: FuturisticColors.primary,
        ),
      ),

      // App bar theme with glowing effect
      appBarTheme: AppBarTheme(
        backgroundColor: FuturisticColors.surface,
        foregroundColor: FuturisticColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: FuturisticColors.textPrimary,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: FuturisticColors.glow.withOpacity(0.3),
              blurRadius: 4,
            ),
          ],
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(
          color: FuturisticColors.textPrimary,
          size: AppSpacing.iconSize,
        ),
        actionsIconTheme: const IconThemeData(
          color: FuturisticColors.textPrimary,
          size: AppSpacing.iconSize,
        ),
      ),

      // Card theme with neon border
      cardTheme: CardThemeData(
        color: FuturisticColors.surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
          side: BorderSide(
            color: FuturisticColors.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(AppSpacing.sm),
      ),

      // Elevated button theme with holographic effect
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: FuturisticColors.primary,
          foregroundColor: FuturisticColors.textInverse,
          elevation: 0,
          shadowColor: FuturisticColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            side: BorderSide(
              color: FuturisticColors.primary.withOpacity(0.5),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: AppTypography.buttonText.copyWith(
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: FuturisticColors.primary.withOpacity(0.5),
                blurRadius: 4,
              ),
            ],
          ),
          minimumSize: const Size(0, AppSpacing.xl * 1.5),
        ),
      ),

      // Outlined button theme with neon outline
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FuturisticColors.primary,
          side: BorderSide(
            color: FuturisticColors.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          textStyle: AppTypography.buttonText.copyWith(
            color: FuturisticColors.primary,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(
                color: FuturisticColors.primary.withOpacity(0.3),
                blurRadius: 2,
              ),
            ],
          ),
          minimumSize: const Size(0, AppSpacing.xl * 1.5),
        ),
      ),

      // Text button theme with glow effect
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: FuturisticColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonText.copyWith(
            color: FuturisticColors.primary,
            shadows: [
              Shadow(
                color: FuturisticColors.primary.withOpacity(0.2),
                blurRadius: 2,
              ),
            ],
          ),
          minimumSize: const Size(0, AppSpacing.xl),
        ),
      ),

      // Input decoration theme with neon borders
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FuturisticColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: BorderSide(
            color: FuturisticColors.outline,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: BorderSide(
            color: FuturisticColors.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: BorderSide(
            color: FuturisticColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: BorderSide(
            color: FuturisticColors.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          borderSide: BorderSide(
            color: FuturisticColors.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: FuturisticColors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: FuturisticColors.textDisabled,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: FuturisticColors.error,
        ),
      ),

      // Chip theme with holographic effect
      chipTheme: ChipThemeData(
        backgroundColor: FuturisticColors.surfaceVariant,
        selectedColor: FuturisticColors.primary,
        disabledColor: FuturisticColors.textDisabled,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: FuturisticColors.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.full),
          side: BorderSide(
            color: FuturisticColors.outline.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),

      // Divider theme with neon glow
      dividerTheme: DividerThemeData(
        color: FuturisticColors.divider,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // Icon theme with glow effect
      iconTheme: const IconThemeData(
        color: FuturisticColors.textPrimary,
        size: AppSpacing.iconSize,
      ),

      // Primary icon theme with enhanced glow
      primaryIconTheme: const IconThemeData(
        color: FuturisticColors.primary,
        size: AppSpacing.iconSize,
      ),

      // Floating action button theme with holographic effect
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: FuturisticColors.primary,
        foregroundColor: FuturisticColors.textInverse,
        elevation: 0,
        shape: const CircleBorder(
          side: BorderSide(
            color: FuturisticColors.primary,
            width: 2,
          ),
        ),
      ),

      // Bottom navigation bar theme with cyber aesthetic
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: FuturisticColors.surface,
        selectedItemColor: FuturisticColors.primary,
        unselectedItemColor: FuturisticColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: FuturisticColors.primary,
              blurRadius: 2,
            ),
          ],
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),

      // Tab bar theme with neon indicators
      tabBarTheme: TabBarThemeData(
        labelColor: FuturisticColors.primary,
        unselectedLabelColor: FuturisticColors.textSecondary,
        indicatorColor: FuturisticColors.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: FuturisticColors.primary,
              blurRadius: 2,
            ),
          ],
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),

      // Dialog theme with futuristic styling
      dialogTheme: DialogThemeData(
        backgroundColor: FuturisticColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
          side: BorderSide(
            color: FuturisticColors.outline,
            width: 1,
          ),
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: FuturisticColors.textPrimary,
          shadows: [
            Shadow(
              color: FuturisticColors.glow.withOpacity(0.3),
              blurRadius: 4,
            ),
          ],
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: FuturisticColors.textPrimary,
        ),
      ),

      // Snack bar theme with cyber styling
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FuturisticColors.surface,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: FuturisticColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          side: BorderSide(
            color: FuturisticColors.outline,
            width: 1,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress indicator theme with neon glow
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: FuturisticColors.primary,
        linearTrackColor: FuturisticColors.surfaceVariant,
        circularTrackColor: FuturisticColors.surfaceVariant,
      ),

      // Switch theme with holographic effect
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FuturisticColors.primary;
          }
          return FuturisticColors.textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FuturisticColors.primary.withOpacity(0.3);
          }
          return FuturisticColors.surfaceVariant;
        }),
      ),

      // Checkbox theme with neon styling
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FuturisticColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(FuturisticColors.textInverse),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
        ),
        side: const BorderSide(
          color: FuturisticColors.outline,
          width: 1,
        ),
      ),

      // Radio theme with cyber styling
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return FuturisticColors.primary;
          }
          return FuturisticColors.textSecondary;
        }),
      ),

      // Slider theme with holographic track
      sliderTheme: SliderThemeData(
        activeTrackColor: FuturisticColors.primary,
        inactiveTrackColor: FuturisticColors.surfaceVariant,
        thumbColor: FuturisticColors.primary,
        overlayColor: FuturisticColors.primary.withOpacity(0.2),
        valueIndicatorColor: FuturisticColors.primary,
        valueIndicatorTextStyle: AppTypography.labelMedium.copyWith(
          color: FuturisticColors.textInverse,
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