import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Theme settings screen for customizing app appearance
class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen>
    with TickerProviderStateMixin {
  // Theme Mode Settings
  ThemeMode _selectedThemeMode = ThemeMode.system;

  // Color Scheme Settings
  String _selectedColorScheme = 'Default';
  bool _useDynamicColors = false;

  // Typography Settings
  double _fontScale = 1.0;
  String _selectedFontFamily = 'Inter';
  bool _useBoldText = false;

  // Accessibility Settings
  bool _highContrastMode = false;
  bool _reducedMotion = false;
  double _borderRadius = 12.0;

  // MBTI Theme Settings
  String _mbtiColorTheme = 'All Types';
  bool _showMbtiGradients = true;
  bool _animatedBackgrounds = true;

  // Animation Controllers
  late AnimationController _previewController;
  late Animation<double> _previewAnimation;

  final List<String> _colorSchemeOptions = [
    'Default',
    'Analyst Blue',
    'Diplomat Green',
    'Explorer Orange',
    'Sentinel Teal',
    'Monochrome',
    'High Contrast',
  ];

  final List<String> _fontFamilyOptions = [
    'Inter',
    'Roboto',
    'Open Sans',
    'Lato',
    'Poppins',
    'System Default',
  ];

  final List<String> _mbtiColorThemeOptions = [
    'All Types',
    'Analysts Only',
    'Diplomats Only',
    'Explorers Only',
    'Sentinels Only',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadThemeSettings();
  }

  void _initializeAnimations() {
    _previewController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _previewAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _previewController, curve: Curves.easeInOut),
    );

    _previewController.repeat(reverse: true);
  }

  void _loadThemeSettings() {
    // Load saved theme settings
    // In a real app, this would load from SharedPreferences or similar
    setState(() {
      // Default values are already set in variable declarations
    });
  }

  @override
  void dispose() {
    _previewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(child: CustomScrollView(slivers: [_buildThemeContent()])),
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
              'Theme & Appearance',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _resetToDefaults,
            icon: Icon(
              Icons.refresh,
              color: AppColors.primary,
              size: AppSpacing.iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeOverview(),
            const SizedBox(height: AppSpacing.xl),
            _buildThemePreview(),
            const SizedBox(height: AppSpacing.xl),
            _buildThemeModeSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildColorSchemeSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildTypographySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildMBTIThemeSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildAccessibilitySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildThemeActions(),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOverview() {
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
            Icons.palette,
            color: AppColors.textInverse,
            size: AppSpacing.iconSize * 2,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Personalize Your Experience',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Customize colors, fonts, and visual elements to match your personality and preferences.',
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

  Widget _buildThemePreview() {
    return AnimatedBuilder(
      animation: _previewAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.preview,
                    color: AppColors.primary,
                    size: AppSpacing.iconSize,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Live Preview',
                    style: AppTypography.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildPreviewCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreviewCard() {
    final animationValue = _previewAnimation.value;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getPreviewGradient(),
          stops: [animationValue * 0.3, 0.7 + animationValue * 0.3],
        ),
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: _getPreviewColor().withOpacity(0.3 * animationValue),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.textInverse.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(_borderRadius * 0.5),
                ),
                child: Icon(
                  Icons.psychology,
                  color: AppColors.textInverse,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MBTI Explorer',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textInverse,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        fontSize:
                            AppTypography.titleMedium.fontSize! * _fontScale,
                        fontFamily:
                            _selectedFontFamily == 'System Default'
                                ? null
                                : _selectedFontFamily,
                      ),
                    ),
                    Text(
                      'Discover your personality',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textInverse.withOpacity(0.8),
                        letterSpacing: 0.3,
                        fontSize:
                            AppTypography.bodySmall.fontSize! * _fontScale,
                        fontFamily:
                            _selectedFontFamily == 'System Default'
                                ? null
                                : _selectedFontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.textInverse.withOpacity(0.2),
              borderRadius: BorderRadius.circular(_borderRadius * 0.5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.3 + animationValue * 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.textInverse,
                  borderRadius: BorderRadius.circular(_borderRadius * 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Theme customization in progress...',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textInverse.withOpacity(0.8),
              letterSpacing: 0.2,
              fontSize: AppTypography.bodySmall.fontSize! * _fontScale,
              fontFamily:
                  _selectedFontFamily == 'System Default'
                      ? null
                      : _selectedFontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeSection() {
    return _buildThemeSection(
      title: 'Theme Mode',
      icon: Icons.brightness_6,
      color: AppColors.primary,
      description: 'Choose between light, dark, or system theme',
      children: [
        _buildRadioTile(
          title: 'Light Theme',
          subtitle: 'Always use light colors',
          value: ThemeMode.light,
          groupValue: _selectedThemeMode,
          onChanged: _updateThemeMode,
          icon: Icons.light_mode,
        ),
        _buildRadioTile(
          title: 'Dark Theme',
          subtitle: 'Always use dark colors',
          value: ThemeMode.dark,
          groupValue: _selectedThemeMode,
          onChanged: _updateThemeMode,
          icon: Icons.dark_mode,
        ),
        _buildRadioTile(
          title: 'System Theme',
          subtitle: 'Follow device settings',
          value: ThemeMode.system,
          groupValue: _selectedThemeMode,
          onChanged: _updateThemeMode,
          icon: Icons.brightness_auto,
        ),
      ],
    );
  }

  Widget _buildColorSchemeSection() {
    return _buildThemeSection(
      title: 'Color Scheme',
      icon: Icons.color_lens,
      color: AppColors.diplomat,
      description: 'Select your preferred color palette',
      children: [
        _buildDropdownTile(
          title: 'Color Scheme',
          subtitle: 'Choose your preferred colors',
          value: _selectedColorScheme,
          options: _colorSchemeOptions,
          onChanged: (value) => setState(() => _selectedColorScheme = value!),
          icon: Icons.palette,
        ),
        _buildSwitchTile(
          title: 'Dynamic Colors',
          subtitle: 'Use colors from your wallpaper (Android 12+)',
          value: _useDynamicColors,
          onChanged: (value) => setState(() => _useDynamicColors = value),
          icon: Icons.auto_awesome,
        ),
        const SizedBox(height: AppSpacing.md),
        _buildColorPreviewRow(),
      ],
    );
  }

  Widget _buildTypographySection() {
    return _buildThemeSection(
      title: 'Typography',
      icon: Icons.text_fields,
      color: AppColors.analyst,
      description: 'Customize text appearance and readability',
      children: [
        _buildDropdownTile(
          title: 'Font Family',
          subtitle: 'Choose your preferred font',
          value: _selectedFontFamily,
          options: _fontFamilyOptions,
          onChanged: (value) => setState(() => _selectedFontFamily = value!),
          icon: Icons.font_download,
        ),
        _buildSliderTile(
          title: 'Font Size',
          subtitle: 'Adjust text size for better readability',
          value: _fontScale,
          min: 0.8,
          max: 1.4,
          divisions: 6,
          onChanged: (value) => setState(() => _fontScale = value),
          icon: Icons.format_size,
          valueLabel: '${(_fontScale * 100).round()}%',
        ),
        _buildSwitchTile(
          title: 'Bold Text',
          subtitle: 'Make text bolder for better visibility',
          value: _useBoldText,
          onChanged: (value) => setState(() => _useBoldText = value),
          icon: Icons.format_bold,
        ),
      ],
    );
  }

  Widget _buildMBTIThemeSection() {
    return _buildThemeSection(
      title: 'MBTI Theme',
      icon: Icons.psychology,
      color: AppColors.explorer,
      description: 'Customize MBTI-specific visual elements',
      children: [
        _buildDropdownTile(
          title: 'MBTI Color Theme',
          subtitle: 'Focus on specific personality type colors',
          value: _mbtiColorTheme,
          options: _mbtiColorThemeOptions,
          onChanged: (value) => setState(() => _mbtiColorTheme = value!),
          icon: Icons.category,
        ),
        _buildSwitchTile(
          title: 'MBTI Gradients',
          subtitle: 'Use gradient backgrounds for personality types',
          value: _showMbtiGradients,
          onChanged: (value) => setState(() => _showMbtiGradients = value),
          icon: Icons.gradient,
        ),
        _buildSwitchTile(
          title: 'Animated Backgrounds',
          subtitle: 'Enable subtle background animations',
          value: _animatedBackgrounds,
          onChanged: (value) => setState(() => _animatedBackgrounds = value),
          icon: Icons.auto_awesome_motion,
        ),
      ],
    );
  }

  Widget _buildAccessibilitySection() {
    return _buildThemeSection(
      title: 'Accessibility',
      icon: Icons.accessibility,
      color: AppColors.sentinel,
      description: 'Improve accessibility and usability',
      children: [
        _buildSwitchTile(
          title: 'High Contrast',
          subtitle: 'Increase color contrast for better visibility',
          value: _highContrastMode,
          onChanged: (value) => setState(() => _highContrastMode = value),
          icon: Icons.contrast,
        ),
        _buildSwitchTile(
          title: 'Reduce Motion',
          subtitle: 'Minimize animations and transitions',
          value: _reducedMotion,
          onChanged: (value) => setState(() => _reducedMotion = value),
          icon: Icons.motion_photos_off,
        ),
        _buildSliderTile(
          title: 'Corner Roundness',
          subtitle: 'Adjust corner radius for better touch targets',
          value: _borderRadius,
          min: 4.0,
          max: 24.0,
          divisions: 10,
          onChanged: (value) => setState(() => _borderRadius = value),
          icon: Icons.rounded_corner,
          valueLabel: '${_borderRadius.round()}px',
        ),
      ],
    );
  }

  Widget _buildThemeActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveThemeSettings,
            icon: const Icon(Icons.save),
            label: Text(
              'Save Theme Settings',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _exportThemeSettings,
            icon: const Icon(Icons.file_download),
            label: Text(
              'Export Theme',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_borderRadius),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          onPressed: _importThemeSettings,
          icon: const Icon(Icons.file_upload),
          label: Text(
            'Import Theme',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection({
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

  Widget _buildRadioTile<T>({
    required String title,
    required String subtitle,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
    required IconData icon,
  }) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: AppSpacing.iconSize),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  subtitle,
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
      activeColor: AppColors.primary,
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required IconData icon,
    required String valueLabel,
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: onChanged,
                  activeColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Text(
                  valueLabel,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorPreviewRow() {
    final colors = _getColorSchemeColors();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Color Preview',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children:
                colors.map((color) {
                  return Expanded(
                    child: Container(
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(
                          _borderRadius * 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // Helper methods for theme customization

  List<Color> _getPreviewGradient() {
    switch (_selectedColorScheme) {
      case 'Analyst Blue':
        return [AppColors.analyst, AppColors.analyst.withOpacity(0.7)];
      case 'Diplomat Green':
        return [AppColors.diplomat, AppColors.diplomat.withOpacity(0.7)];
      case 'Explorer Orange':
        return [AppColors.explorer, AppColors.explorer.withOpacity(0.7)];
      case 'Sentinel Teal':
        return [AppColors.sentinel, AppColors.sentinel.withOpacity(0.7)];
      case 'Monochrome':
        return [AppColors.textPrimary, AppColors.textSecondary];
      case 'High Contrast':
        return [Colors.black, Colors.white];
      default:
        return AppColors.primaryGradient;
    }
  }

  Color _getPreviewColor() {
    switch (_selectedColorScheme) {
      case 'Analyst Blue':
        return AppColors.analyst;
      case 'Diplomat Green':
        return AppColors.diplomat;
      case 'Explorer Orange':
        return AppColors.explorer;
      case 'Sentinel Teal':
        return AppColors.sentinel;
      case 'Monochrome':
        return AppColors.textPrimary;
      case 'High Contrast':
        return Colors.black;
      default:
        return AppColors.primary;
    }
  }

  List<Color> _getColorSchemeColors() {
    switch (_selectedColorScheme) {
      case 'Analyst Blue':
        return [
          AppColors.analyst,
          AppColors.analyst.withOpacity(0.8),
          AppColors.analyst.withOpacity(0.6),
          AppColors.analyst.withOpacity(0.4),
          AppColors.analyst.withOpacity(0.2),
        ];
      case 'Diplomat Green':
        return [
          AppColors.diplomat,
          AppColors.diplomat.withOpacity(0.8),
          AppColors.diplomat.withOpacity(0.6),
          AppColors.diplomat.withOpacity(0.4),
          AppColors.diplomat.withOpacity(0.2),
        ];
      case 'Explorer Orange':
        return [
          AppColors.explorer,
          AppColors.explorer.withOpacity(0.8),
          AppColors.explorer.withOpacity(0.6),
          AppColors.explorer.withOpacity(0.4),
          AppColors.explorer.withOpacity(0.2),
        ];
      case 'Sentinel Teal':
        return [
          AppColors.sentinel,
          AppColors.sentinel.withOpacity(0.8),
          AppColors.sentinel.withOpacity(0.6),
          AppColors.sentinel.withOpacity(0.4),
          AppColors.sentinel.withOpacity(0.2),
        ];
      case 'Monochrome':
        return [
          AppColors.textPrimary,
          AppColors.textSecondary,
          AppColors.textDisabled,
          AppColors.divider,
          AppColors.surfaceVariant,
        ];
      case 'High Contrast':
        return [
          Colors.black,
          Colors.grey[800]!,
          Colors.grey[600]!,
          Colors.grey[400]!,
          Colors.grey[200]!,
        ];
      default:
        return [
          AppColors.primary,
          AppColors.primaryLight,
          AppColors.secondary,
          AppColors.accent,
          AppColors.surface,
        ];
    }
  }

  void _updateThemeMode(ThemeMode? mode) {
    if (mode != null) {
      setState(() {
        _selectedThemeMode = mode;
      });
    }
  }

  void _resetToDefaults() {
    setState(() {
      _selectedThemeMode = ThemeMode.system;
      _selectedColorScheme = 'Default';
      _useDynamicColors = false;
      _fontScale = 1.0;
      _selectedFontFamily = 'Inter';
      _useBoldText = false;
      _highContrastMode = false;
      _reducedMotion = false;
      _borderRadius = 12.0;
      _mbtiColorTheme = 'All Types';
      _showMbtiGradients = true;
      _animatedBackgrounds = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Theme settings reset to defaults',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _saveThemeSettings() {
    // Save theme settings to SharedPreferences or similar
    print('💾 Saving theme settings:');
    print('   Theme Mode: $_selectedThemeMode');
    print('   Color Scheme: $_selectedColorScheme');
    print('   Font Scale: $_fontScale');
    print('   Font Family: $_selectedFontFamily');
    print('   Border Radius: $_borderRadius');
    print('   MBTI Color Theme: $_mbtiColorTheme');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Theme settings saved successfully!',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _exportThemeSettings() {
    // Export theme settings as JSON
    final themeData = {
      'themeMode': _selectedThemeMode.toString(),
      'colorScheme': _selectedColorScheme,
      'fontScale': _fontScale,
      'fontFamily': _selectedFontFamily,
      'borderRadius': _borderRadius,
      'mbtiColorTheme': _mbtiColorTheme,
      'showMbtiGradients': _showMbtiGradients,
      'animatedBackgrounds': _animatedBackgrounds,
      'highContrast': _highContrastMode,
      'reducedMotion': _reducedMotion,
    };

    print('📤 Exporting theme: $themeData');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Theme exported to downloads folder',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _importThemeSettings() {
    // Import theme settings from file
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Theme import coming soon!',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.warning,
      ),
    );
  }
}
