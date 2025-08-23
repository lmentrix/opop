import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Accessibility settings screen with comprehensive options for inclusive MBTI experience
class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen>
    with TickerProviderStateMixin {
  // Visual Accessibility Settings
  double _fontSize = 1.0;
  double _lineHeight = 1.5;
  double _letterSpacing = 0.0;
  bool _boldText = false;
  bool _highContrast = false;

  String _colorBlindnessFilter = 'None';
  bool _reduceAnimations = false;
  bool _flashingContent = true;

  // Interaction Accessibility Settings
  bool _largerTouchTargets = false;
  double _touchTargetSize = 48.0;
  bool _hapticFeedback = true;
  bool _soundEffects = true;
  double _longPressDelay = 500.0;
  bool _singleTapMode = false;

  // Cognitive Accessibility Settings
  bool _simplifiedInterface = false;
  bool _showDescriptions = true;
  bool _progressIndicators = true;
  bool _confirmationDialogs = true;
  String _readingSpeed = 'Normal';
  bool _autoScroll = false;

  // MBTI-Specific Accessibility
  bool _personalityColorCoding = true;
  bool _mbtiSymbols = false;
  bool _typeDescriptions = true;
  bool _cognitiveIcons = true;
  String _personalityDisplay = 'Full Names';

  // Audio & Voice Settings
  bool _screenReader = false;
  bool _voiceCommands = false;
  double _speechRate = 1.0;
  double _speechPitch = 1.0;
  String _voiceGender = 'System Default';
  bool _audioDescriptions = false;

  // Navigation Accessibility
  bool _focusIndicators = true;
  bool _skipLinks = true;
  bool _breadcrumbs = true;
  String _navigationStyle = 'Standard';
  bool _gestureAlternatives = false;

  // Animation Controllers
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  final List<String> _colorBlindnessOptions = [
    'None',
    'Protanopia (Red-blind)',
    'Deuteranopia (Green-blind)',
    'Tritanopia (Blue-blind)',
    'Protanomaly (Red-weak)',
    'Deuteranomaly (Green-weak)',
    'Tritanomaly (Blue-weak)',
    'Achromatopsia (Total color blindness)',
  ];

  final List<String> _readingSpeedOptions = [
    'Very Slow',
    'Slow',
    'Normal',
    'Fast',
    'Very Fast',
  ];

  final List<String> _personalityDisplayOptions = [
    'Full Names',
    'Abbreviations Only',
    'Icons Only',
    'Colors Only',
    'Mixed Format',
  ];

  final List<String> _voiceGenderOptions = [
    'System Default',
    'Female',
    'Male',
    'Neutral',
  ];

  final List<String> _navigationStyleOptions = [
    'Standard',
    'Tab Navigation',
    'Voice Navigation',
    'Gesture Navigation',
    'Switch Control',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAccessibilitySettings();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));

    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  void _loadAccessibilitySettings() {
    // Load saved accessibility settings
    // In a real app, this would load from SharedPreferences or similar
    setState(() {
      // Default values are already set in variable declarations
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: CustomScrollView(slivers: [_buildAccessibilityContent()]),
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
              'Accessibility',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _runAccessibilityCheck,
            icon: AnimatedBuilder(
              animation: _rotateController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimation.value * 2.0 * 3.14159,
                  child: Icon(
                    Icons.accessibility_new,
                    color: AppColors.primary,
                    size: AppSpacing.iconSize,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccessibilityOverview(),
            const SizedBox(height: AppSpacing.xl),
            _buildLivePreview(),
            const SizedBox(height: AppSpacing.xl),
            _buildVisualAccessibilitySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildInteractionAccessibilitySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildCognitiveAccessibilitySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildMBTIAccessibilitySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildAudioAccessibilitySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildNavigationAccessibilitySection(),
            const SizedBox(height: AppSpacing.xl),
            _buildAccessibilityActions(),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityOverview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.diplomat, AppColors.diplomat.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.diplomat.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.textInverse.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.full),
                  ),
                  child: Icon(
                    Icons.accessibility_new,
                    color: AppColors.textInverse,
                    size: 40,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Inclusive MBTI Experience',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Customize your personality journey to match your unique needs and preferences.',
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

  Widget _buildLivePreview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _highContrast ? Colors.black : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border:
            _highContrast ? Border.all(color: Colors.white, width: 2) : null,
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
                color: _highContrast ? Colors.white : AppColors.primary,
                size: AppSpacing.iconSize,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Live Preview',
                style: AppTypography.titleLarge.copyWith(
                  color: _highContrast ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontSize: AppTypography.titleLarge.fontSize! * _fontSize,
                  height: _lineHeight,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildPersonalityPreview(),
        ],
      ),
    );
  }

  Widget _buildPersonalityPreview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient:
            _personalityColorCoding
                ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.analyst,
                    AppColors.analyst.withOpacity(0.7),
                  ],
                )
                : null,
        color: _personalityColorCoding ? null : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border:
            _highContrast ? Border.all(color: Colors.white, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (_cognitiveIcons) ...[
                Icon(
                  Icons.psychology,
                  color:
                      _personalityColorCoding
                          ? AppColors.textInverse
                          : AppColors.analyst,
                  size: AppSpacing.iconSize * _fontSize,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (_mbtiSymbols) ...[
                Text('🧠', style: TextStyle(fontSize: 24 * _fontSize)),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                _getPersonalityDisplayText(),
                style: AppTypography.titleMedium.copyWith(
                  color:
                      _personalityColorCoding
                          ? AppColors.textInverse
                          : (_highContrast
                              ? Colors.black
                              : AppColors.textPrimary),
                  fontWeight: _boldText ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: _letterSpacing,
                  fontSize: AppTypography.titleMedium.fontSize! * _fontSize,
                  height: _lineHeight,
                ),
              ),
            ],
          ),
          if (_typeDescriptions) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'The Architect - Strategic thinkers with a plan for everything.',
              style: AppTypography.bodyMedium.copyWith(
                color:
                    _personalityColorCoding
                        ? AppColors.textInverse.withOpacity(0.9)
                        : (_highContrast
                            ? Colors.black
                            : AppColors.textSecondary),
                fontWeight: _boldText ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: _letterSpacing,
                fontSize: AppTypography.bodyMedium.fontSize! * _fontSize,
                height: _lineHeight,
              ),
            ),
          ],
          if (_showDescriptions) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This is how your personality type will appear throughout the app with your current accessibility settings.',
              style: AppTypography.bodySmall.copyWith(
                color:
                    _personalityColorCoding
                        ? AppColors.textInverse.withOpacity(0.7)
                        : (_highContrast
                            ? Colors.grey[700]
                            : AppColors.textDisabled),
                fontWeight: _boldText ? FontWeight.w500 : FontWeight.w400,
                letterSpacing: _letterSpacing,
                fontSize: AppTypography.bodySmall.fontSize! * _fontSize,
                height: _lineHeight,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVisualAccessibilitySection() {
    return _buildAccessibilitySection(
      title: 'Visual Accessibility',
      icon: Icons.visibility,
      color: AppColors.analyst,
      description: 'Customize visual elements for better readability',
      children: [
        _buildSliderTile(
          title: 'Font Size',
          subtitle: 'Adjust text size for better readability',
          value: _fontSize,
          min: 0.8,
          max: 2.0,
          divisions: 12,
          onChanged: (value) => setState(() => _fontSize = value),
          icon: Icons.format_size,
          valueDisplay: '${(_fontSize * 100).round()}%',
        ),
        _buildSliderTile(
          title: 'Line Height',
          subtitle: 'Adjust spacing between lines',
          value: _lineHeight,
          min: 1.0,
          max: 2.5,
          divisions: 15,
          onChanged: (value) => setState(() => _lineHeight = value),
          icon: Icons.format_line_spacing,
          valueDisplay: '${_lineHeight.toStringAsFixed(1)}x',
        ),
        _buildSliderTile(
          title: 'Letter Spacing',
          subtitle: 'Adjust spacing between letters',
          value: _letterSpacing,
          min: -1.0,
          max: 3.0,
          divisions: 40,
          onChanged: (value) => setState(() => _letterSpacing = value),
          icon: Icons.text_fields,
          valueDisplay:
              _letterSpacing == 0.0
                  ? 'Normal'
                  : '${_letterSpacing.toStringAsFixed(1)}px',
        ),
        _buildSwitchTile(
          title: 'Bold Text',
          subtitle: 'Make all text appear bolder',
          value: _boldText,
          onChanged: (value) => setState(() => _boldText = value),
          icon: Icons.format_bold,
        ),
        _buildSwitchTile(
          title: 'High Contrast',
          subtitle: 'Increase contrast for better visibility',
          value: _highContrast,
          onChanged: (value) => setState(() => _highContrast = value),
          icon: Icons.contrast,
        ),
        _buildDropdownTile(
          title: 'Color Blindness Filter',
          subtitle: 'Adjust colors for color vision differences',
          value: _colorBlindnessFilter,
          options: _colorBlindnessOptions,
          onChanged: (value) => setState(() => _colorBlindnessFilter = value!),
          icon: Icons.color_lens,
        ),
        _buildSwitchTile(
          title: 'Reduce Animations',
          subtitle: 'Minimize motion for sensitive users',
          value: _reduceAnimations,
          onChanged: (value) => setState(() => _reduceAnimations = value),
          icon: Icons.motion_photos_off,
        ),
        _buildSwitchTile(
          title: 'Allow Flashing Content',
          subtitle: 'Show content with rapid color changes',
          value: _flashingContent,
          onChanged: (value) => setState(() => _flashingContent = value),
          icon: Icons.flash_off,
        ),
      ],
    );
  }

  Widget _buildInteractionAccessibilitySection() {
    return _buildAccessibilitySection(
      title: 'Interaction Accessibility',
      icon: Icons.touch_app,
      color: AppColors.explorer,
      description: 'Customize touch and interaction settings',
      children: [
        _buildSwitchTile(
          title: 'Larger Touch Targets',
          subtitle: 'Increase size of buttons and interactive elements',
          value: _largerTouchTargets,
          onChanged: (value) => setState(() => _largerTouchTargets = value),
          icon: Icons.touch_app,
        ),
        _buildSliderTile(
          title: 'Touch Target Size',
          subtitle: 'Minimum size for interactive elements',
          value: _touchTargetSize,
          min: 40.0,
          max: 80.0,
          divisions: 8,
          onChanged: (value) => setState(() => _touchTargetSize = value),
          icon: Icons.crop_free,
          valueDisplay: '${_touchTargetSize.round()}dp',
        ),
        _buildSwitchTile(
          title: 'Haptic Feedback',
          subtitle: 'Vibrate on interactions',
          value: _hapticFeedback,
          onChanged: (value) => setState(() => _hapticFeedback = value),
          icon: Icons.vibration,
        ),
        _buildSwitchTile(
          title: 'Sound Effects',
          subtitle: 'Play sounds for interactions',
          value: _soundEffects,
          onChanged: (value) => setState(() => _soundEffects = value),
          icon: Icons.volume_up,
        ),
        _buildSliderTile(
          title: 'Long Press Delay',
          subtitle: 'Time required for long press actions',
          value: _longPressDelay,
          min: 200.0,
          max: 2000.0,
          divisions: 18,
          onChanged: (value) => setState(() => _longPressDelay = value),
          icon: Icons.timer,
          valueDisplay: '${(_longPressDelay / 1000).toStringAsFixed(1)}s',
        ),
        _buildSwitchTile(
          title: 'Single Tap Mode',
          subtitle: 'Use single tap instead of double tap',
          value: _singleTapMode,
          onChanged: (value) => setState(() => _singleTapMode = value),
          icon: Icons.touch_app,
        ),
      ],
    );
  }

  Widget _buildCognitiveAccessibilitySection() {
    return _buildAccessibilitySection(
      title: 'Cognitive Accessibility',
      icon: Icons.psychology,
      color: AppColors.sentinel,
      description: 'Simplify interface and provide helpful guidance',
      children: [
        _buildSwitchTile(
          title: 'Simplified Interface',
          subtitle: 'Reduce visual complexity and distractions',
          value: _simplifiedInterface,
          onChanged: (value) => setState(() => _simplifiedInterface = value),
          icon: Icons.apps,
        ),
        _buildSwitchTile(
          title: 'Show Descriptions',
          subtitle: 'Display helpful explanations for features',
          value: _showDescriptions,
          onChanged: (value) => setState(() => _showDescriptions = value),
          icon: Icons.help_outline,
        ),
        _buildSwitchTile(
          title: 'Progress Indicators',
          subtitle: 'Show progress bars and completion status',
          value: _progressIndicators,
          onChanged: (value) => setState(() => _progressIndicators = value),
          icon: Icons.linear_scale,
        ),
        _buildSwitchTile(
          title: 'Confirmation Dialogs',
          subtitle: 'Ask for confirmation before important actions',
          value: _confirmationDialogs,
          onChanged: (value) => setState(() => _confirmationDialogs = value),
          icon: Icons.check_circle_outline,
        ),
        _buildDropdownTile(
          title: 'Reading Speed',
          subtitle: 'Adjust timing for auto-advancing content',
          value: _readingSpeed,
          options: _readingSpeedOptions,
          onChanged: (value) => setState(() => _readingSpeed = value!),
          icon: Icons.speed,
        ),
        _buildSwitchTile(
          title: 'Auto Scroll',
          subtitle: 'Automatically scroll through long content',
          value: _autoScroll,
          onChanged: (value) => setState(() => _autoScroll = value),
          icon: Icons.vertical_align_center,
        ),
      ],
    );
  }

  Widget _buildMBTIAccessibilitySection() {
    return _buildAccessibilitySection(
      title: 'MBTI Accessibility',
      icon: Icons.psychology,
      color: AppColors.primary,
      description: 'Customize personality type display and interaction',
      children: [
        _buildSwitchTile(
          title: 'Personality Color Coding',
          subtitle: 'Use colors to represent different personality types',
          value: _personalityColorCoding,
          onChanged: (value) => setState(() => _personalityColorCoding = value),
          icon: Icons.palette,
        ),
        _buildSwitchTile(
          title: 'MBTI Symbols',
          subtitle: 'Show emoji symbols for personality types',
          value: _mbtiSymbols,
          onChanged: (value) => setState(() => _mbtiSymbols = value),
          icon: Icons.emoji_symbols,
        ),
        _buildSwitchTile(
          title: 'Type Descriptions',
          subtitle: 'Display detailed personality descriptions',
          value: _typeDescriptions,
          onChanged: (value) => setState(() => _typeDescriptions = value),
          icon: Icons.description,
        ),
        _buildSwitchTile(
          title: 'Cognitive Function Icons',
          subtitle: 'Show icons for cognitive functions',
          value: _cognitiveIcons,
          onChanged: (value) => setState(() => _cognitiveIcons = value),
          icon: Icons.psychology,
        ),
        _buildDropdownTile(
          title: 'Personality Display',
          subtitle: 'How personality types are shown',
          value: _personalityDisplay,
          options: _personalityDisplayOptions,
          onChanged: (value) => setState(() => _personalityDisplay = value!),
          icon: Icons.person,
        ),
      ],
    );
  }

  Widget _buildAudioAccessibilitySection() {
    return _buildAccessibilitySection(
      title: 'Audio & Voice',
      icon: Icons.record_voice_over,
      color: AppColors.diplomat,
      description: 'Configure audio feedback and voice assistance',
      children: [
        _buildSwitchTile(
          title: 'Screen Reader Support',
          subtitle: 'Optimize for screen reading software',
          value: _screenReader,
          onChanged: (value) => setState(() => _screenReader = value),
          icon: Icons.record_voice_over,
        ),
        _buildSwitchTile(
          title: 'Voice Commands',
          subtitle: 'Enable voice control for navigation',
          value: _voiceCommands,
          onChanged: (value) => setState(() => _voiceCommands = value),
          icon: Icons.mic,
        ),
        _buildSliderTile(
          title: 'Speech Rate',
          subtitle: 'Speed of text-to-speech',
          value: _speechRate,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          onChanged: (value) => setState(() => _speechRate = value),
          icon: Icons.speed,
          valueDisplay: '${_speechRate.toStringAsFixed(1)}x',
        ),
        _buildSliderTile(
          title: 'Speech Pitch',
          subtitle: 'Pitch of text-to-speech voice',
          value: _speechPitch,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          onChanged: (value) => setState(() => _speechPitch = value),
          icon: Icons.graphic_eq,
          valueDisplay: '${_speechPitch.toStringAsFixed(1)}x',
        ),
        _buildDropdownTile(
          title: 'Voice Gender',
          subtitle: 'Preferred voice for text-to-speech',
          value: _voiceGender,
          options: _voiceGenderOptions,
          onChanged: (value) => setState(() => _voiceGender = value!),
          icon: Icons.person,
        ),
        _buildSwitchTile(
          title: 'Audio Descriptions',
          subtitle: 'Describe visual content with audio',
          value: _audioDescriptions,
          onChanged: (value) => setState(() => _audioDescriptions = value),
          icon: Icons.audiotrack,
        ),
      ],
    );
  }

  Widget _buildNavigationAccessibilitySection() {
    return _buildAccessibilitySection(
      title: 'Navigation Accessibility',
      icon: Icons.navigation,
      color: AppColors.explorer,
      description: 'Customize navigation and focus behavior',
      children: [
        _buildSwitchTile(
          title: 'Focus Indicators',
          subtitle: 'Show clear focus outlines for keyboard navigation',
          value: _focusIndicators,
          onChanged: (value) => setState(() => _focusIndicators = value),
          icon: Icons.center_focus_strong,
        ),
        _buildSwitchTile(
          title: 'Skip Links',
          subtitle: 'Provide shortcuts to main content',
          value: _skipLinks,
          onChanged: (value) => setState(() => _skipLinks = value),
          icon: Icons.skip_next,
        ),
        _buildSwitchTile(
          title: 'Breadcrumbs',
          subtitle: 'Show navigation path and location',
          value: _breadcrumbs,
          onChanged: (value) => setState(() => _breadcrumbs = value),
          icon: Icons.linear_scale,
        ),
        _buildDropdownTile(
          title: 'Navigation Style',
          subtitle: 'Preferred method of navigation',
          value: _navigationStyle,
          options: _navigationStyleOptions,
          onChanged: (value) => setState(() => _navigationStyle = value!),
          icon: Icons.navigation,
        ),
        _buildSwitchTile(
          title: 'Gesture Alternatives',
          subtitle: 'Provide button alternatives to gestures',
          value: _gestureAlternatives,
          onChanged: (value) => setState(() => _gestureAlternatives = value),
          icon: Icons.pan_tool,
        ),
      ],
    );
  }

  Widget _buildAccessibilityActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveAccessibilitySettings,
            icon: const Icon(Icons.save),
            label: Text(
              'Save Accessibility Settings',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                fontSize: AppTypography.titleMedium.fontSize! * _fontSize,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textInverse,
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg * (_largerTouchTargets ? 1.5 : 1.0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              minimumSize: Size(0, _touchTargetSize),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _runAccessibilityCheck,
            icon: const Icon(Icons.accessibility_new),
            label: Text(
              'Run Accessibility Check',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontSize: AppTypography.titleMedium.fontSize! * _fontSize,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg * (_largerTouchTargets ? 1.5 : 1.0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              minimumSize: Size(0, _touchTargetSize),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          onPressed: _resetToDefaults,
          icon: const Icon(Icons.restore),
          label: Text(
            'Reset to Defaults',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              fontSize: AppTypography.titleMedium.fontSize! * _fontSize,
            ),
          ),
          style: TextButton.styleFrom(minimumSize: Size(0, _touchTargetSize)),
        ),
      ],
    );
  }

  Widget _buildAccessibilitySection({
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
                      color:
                          _highContrast ? Colors.black : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      fontSize: AppTypography.titleLarge.fontSize! * _fontSize,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color:
                          _highContrast
                              ? Colors.grey[700]
                              : AppColors.textSecondary,
                      letterSpacing: 0.3,
                      fontSize: AppTypography.bodySmall.fontSize! * _fontSize,
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
            color: _highContrast ? Colors.white : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            border:
                _highContrast
                    ? Border.all(color: Colors.black, width: 1)
                    : null,
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
    return Container(
      constraints: BoxConstraints(
        minHeight: _largerTouchTargets ? _touchTargetSize : 48.0,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: _highContrast ? Colors.black : AppColors.textSecondary,
          size: AppSpacing.iconSize * (_largerTouchTargets ? 1.2 : 1.0),
        ),
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: _highContrast ? Colors.black : AppColors.textPrimary,
            fontWeight: _boldText ? FontWeight.w800 : FontWeight.w600,
            letterSpacing: _letterSpacing,
            fontSize: AppTypography.titleMedium.fontSize! * _fontSize,
            height: _lineHeight,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: _highContrast ? Colors.grey[700] : AppColors.textSecondary,
            letterSpacing: _letterSpacing,
            fontSize: AppTypography.bodySmall.fontSize! * _fontSize,
            height: _lineHeight,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: (newValue) {
            if (_hapticFeedback) {
              HapticFeedback.lightImpact();
            }
            onChanged(newValue);
          },
          activeColor: AppColors.primary,
        ),
      ),
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
    required String valueDisplay,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: _largerTouchTargets ? _touchTargetSize + 20 : 68.0,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: _highContrast ? Colors.black : AppColors.textSecondary,
          size: AppSpacing.iconSize * (_largerTouchTargets ? 1.2 : 1.0),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  color: _highContrast ? Colors.black : AppColors.textPrimary,
                  fontWeight: _boldText ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: _letterSpacing,
                  fontSize: AppTypography.titleMedium.fontSize! * _fontSize,
                  height: _lineHeight,
                ),
              ),
            ),
            Text(
              valueDisplay,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: AppTypography.labelMedium.fontSize! * _fontSize,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color:
                    _highContrast ? Colors.grey[700] : AppColors.textSecondary,
                letterSpacing: _letterSpacing,
                fontSize: AppTypography.bodySmall.fontSize! * _fontSize,
                height: _lineHeight,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SliderTheme(
              data: SliderTheme.of(
                context,
              ).copyWith(trackHeight: _largerTouchTargets ? 6.0 : 4.0),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: (newValue) {
                  if (_hapticFeedback) {
                    HapticFeedback.selectionClick();
                  }
                  onChanged(newValue);
                },
                activeColor: AppColors.primary,
                inactiveColor:
                    _highContrast ? Colors.grey[400] : AppColors.surfaceVariant,
              ),
            ),
          ],
        ),
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
    return Container(
      constraints: BoxConstraints(
        minHeight: _largerTouchTargets ? _touchTargetSize : 48.0,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: _highContrast ? Colors.black : AppColors.textSecondary,
          size: AppSpacing.iconSize * (_largerTouchTargets ? 1.2 : 1.0),
        ),
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: _highContrast ? Colors.black : AppColors.textPrimary,
            fontWeight: _boldText ? FontWeight.w800 : FontWeight.w600,
            letterSpacing: _letterSpacing,
            fontSize: AppTypography.titleMedium.fontSize! * _fontSize,
            height: _lineHeight,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: _highContrast ? Colors.grey[700] : AppColors.textSecondary,
            letterSpacing: _letterSpacing,
            fontSize: AppTypography.bodySmall.fontSize! * _fontSize,
            height: _lineHeight,
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
                      fontSize: AppTypography.bodyMedium.fontSize! * _fontSize,
                    ),
                  ),
                );
              }).toList(),
          onChanged: (newValue) {
            if (_hapticFeedback) {
              HapticFeedback.selectionClick();
            }
            onChanged(newValue);
          },
        ),
      ),
    );
  }

  // Helper methods

  String _getPersonalityDisplayText() {
    switch (_personalityDisplay) {
      case 'Full Names':
        return 'INTJ - The Architect';
      case 'Abbreviations Only':
        return 'INTJ';
      case 'Icons Only':
        return '🏗️';
      case 'Colors Only':
        return '■ Analyst';
      case 'Mixed Format':
        return 'INTJ 🏗️';
      default:
        return 'INTJ - The Architect';
    }
  }

  void _saveAccessibilitySettings() {
    // Save accessibility settings to SharedPreferences or similar
    print('♿ Saving accessibility settings:');
    print('   Font Size: ${(_fontSize * 100).round()}%');
    print('   High Contrast: $_highContrast');
    print('   Bold Text: $_boldText');
    print('   Color Blindness Filter: $_colorBlindnessFilter');

    if (_hapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Accessibility settings saved successfully!',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
            fontSize: AppTypography.bodyMedium.fontSize! * _fontSize,
          ),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _runAccessibilityCheck() {
    if (_hapticFeedback) {
      HapticFeedback.lightImpact();
    }

    // Simulate accessibility audit
    final issues = <String>[];

    if (_fontSize < 1.0) {
      issues.add('Consider increasing font size for better readability');
    }
    if (!_personalityColorCoding && !_mbtiSymbols) {
      issues.add('Enable visual indicators for MBTI types');
    }
    if (!_confirmationDialogs) {
      issues.add(
        'Consider enabling confirmation dialogs for important actions',
      );
    }

    final message =
        issues.isEmpty
            ? 'Great! Your accessibility settings look good.'
            : 'Found ${issues.length} suggestions:\n• ${issues.join('\n• ')}';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Accessibility Check',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                fontSize: AppTypography.titleLarge.fontSize! * _fontSize,
              ),
            ),
            content: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                letterSpacing: 0.3,
                fontSize: AppTypography.bodyMedium.fontSize! * _fontSize,
                height: _lineHeight,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Got it',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontSize: AppTypography.labelLarge.fontSize! * _fontSize,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _resetToDefaults() {
    if (_confirmationDialogs) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                'Reset Accessibility Settings',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontSize: AppTypography.titleLarge.fontSize! * _fontSize,
                ),
              ),
              content: Text(
                'This will reset all accessibility settings to their default values. Are you sure?',
                style: AppTypography.bodyMedium.copyWith(
                  letterSpacing: 0.3,
                  fontSize: AppTypography.bodyMedium.fontSize! * _fontSize,
                  height: _lineHeight,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: AppTypography.labelLarge.fontSize! * _fontSize,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _performReset();
                  },
                  child: Text(
                    'Reset',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: AppTypography.labelLarge.fontSize! * _fontSize,
                    ),
                  ),
                ),
              ],
            ),
      );
    } else {
      _performReset();
    }
  }

  void _performReset() {
    setState(() {
      _fontSize = 1.0;
      _lineHeight = 1.5;
      _letterSpacing = 0.0;
      _boldText = false;
      _highContrast = false;
      _colorBlindnessFilter = 'None';
      _reduceAnimations = false;
      _largerTouchTargets = false;
      _touchTargetSize = 48.0;
      _hapticFeedback = true;
      _soundEffects = true;
      _personalityColorCoding = true;
      _mbtiSymbols = false;
      _typeDescriptions = true;
      _personalityDisplay = 'Full Names';
    });

    if (_hapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Accessibility settings reset to defaults',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
