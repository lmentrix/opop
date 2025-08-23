import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Language settings screen for selecting app language and localization preferences
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with TickerProviderStateMixin {
  // Language Settings
  String _selectedLanguage = 'English (US)';
  String _selectedRegion = 'United States';
  bool _useSystemLanguage = false;

  // Localization Settings
  String _dateFormat = 'MM/DD/YYYY';
  String _timeFormat = '12-hour';
  String _numberFormat = '1,234.56';
  String _currencyFormat = 'USD (\$)';
  bool _useMetricUnits = false;

  // MBTI Content Settings
  bool _translateMbtiContent = true;
  bool _showOriginalTerms = false;
  String _mbtiContentLanguage = 'Auto';

  // Animation Controllers
  late AnimationController _flagController;
  late Animation<double> _flagAnimation;

  final List<Map<String, dynamic>> _availableLanguages = [
    {
      'name': 'English (US)',
      'nativeName': 'English',
      'code': 'en_US',
      'flag': '🇺🇸',
      'region': 'United States',
      'progress': 100,
    },
    {
      'name': 'English (UK)',
      'nativeName': 'English',
      'code': 'en_GB',
      'flag': '🇬🇧',
      'region': 'United Kingdom',
      'progress': 100,
    },
    {
      'name': 'Spanish',
      'nativeName': 'Español',
      'code': 'es_ES',
      'flag': '🇪🇸',
      'region': 'Spain',
      'progress': 95,
    },
    {
      'name': 'French',
      'nativeName': 'Français',
      'code': 'fr_FR',
      'flag': '🇫🇷',
      'region': 'France',
      'progress': 90,
    },
    {
      'name': 'German',
      'nativeName': 'Deutsch',
      'code': 'de_DE',
      'flag': '🇩🇪',
      'region': 'Germany',
      'progress': 88,
    },
    {
      'name': 'Italian',
      'nativeName': 'Italiano',
      'code': 'it_IT',
      'flag': '🇮🇹',
      'region': 'Italy',
      'progress': 85,
    },
    {
      'name': 'Portuguese (Brazil)',
      'nativeName': 'Português',
      'code': 'pt_BR',
      'flag': '🇧🇷',
      'region': 'Brazil',
      'progress': 82,
    },
    {
      'name': 'Japanese',
      'nativeName': '日本語',
      'code': 'ja_JP',
      'flag': '🇯🇵',
      'region': 'Japan',
      'progress': 75,
    },
    {
      'name': 'Korean',
      'nativeName': '한국어',
      'code': 'ko_KR',
      'flag': '🇰🇷',
      'region': 'South Korea',
      'progress': 70,
    },
    {
      'name': 'Chinese (Simplified)',
      'nativeName': '简体中文',
      'code': 'zh_CN',
      'flag': '🇨🇳',
      'region': 'China',
      'progress': 65,
    },
    {
      'name': 'Chinese (Traditional)',
      'nativeName': '繁體中文',
      'code': 'zh_TW',
      'flag': '🇹🇼',
      'region': 'Taiwan',
      'progress': 60,
    },
    {
      'name': 'Russian',
      'nativeName': 'Русский',
      'code': 'ru_RU',
      'flag': '🇷🇺',
      'region': 'Russia',
      'progress': 55,
    },
    {
      'name': 'Arabic',
      'nativeName': 'العربية',
      'code': 'ar_SA',
      'flag': '🇸🇦',
      'region': 'Saudi Arabia',
      'progress': 50,
    },
    {
      'name': 'Hindi',
      'nativeName': 'हिन्दी',
      'code': 'hi_IN',
      'flag': '🇮🇳',
      'region': 'India',
      'progress': 45,
    },
  ];

  final List<String> _dateFormatOptions = [
    'MM/DD/YYYY',
    'DD/MM/YYYY',
    'YYYY-MM-DD',
    'DD MMM YYYY',
    'MMM DD, YYYY',
  ];

  final List<String> _timeFormatOptions = ['12-hour', '24-hour'];

  final List<String> _numberFormatOptions = [
    '1,234.56',
    '1.234,56',
    '1 234,56',
    '1234.56',
  ];

  final List<String> _currencyFormatOptions = [
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
    'JPY (¥)',
    'CNY (¥)',
    'KRW (₩)',
  ];

  final List<String> _mbtiContentLanguageOptions = [
    'Auto',
    'English Only',
    'Native Language',
    'Both Languages',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadLanguageSettings();
  }

  void _initializeAnimations() {
    _flagController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _flagAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flagController, curve: Curves.easeInOut),
    );

    _flagController.repeat(reverse: true);
  }

  void _loadLanguageSettings() {
    // Load saved language settings
    // In a real app, this would load from SharedPreferences or similar
    setState(() {
      // Default values are already set in variable declarations
    });
  }

  @override
  void dispose() {
    _flagController.dispose();
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
              child: CustomScrollView(slivers: [_buildLanguageContent()]),
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
              'Language & Region',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _downloadLanguagePack,
            icon: Icon(
              Icons.download,
              color: AppColors.primary,
              size: AppSpacing.iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLanguageOverview(),
            const SizedBox(height: AppSpacing.xl),
            _buildCurrentLanguagePreview(),
            const SizedBox(height: AppSpacing.xl),
            _buildLanguageSelectionSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildLocalizationSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildMBTIContentSection(),
            const SizedBox(height: AppSpacing.xl),
            _buildLanguageActions(),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOverview() {
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
          AnimatedBuilder(
            animation: _flagAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + _flagAnimation.value * 0.1,
                child: Text(
                  _getCurrentLanguageFlag(),
                  style: const TextStyle(fontSize: 48),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Speak Your Language',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Choose your preferred language and customize regional settings for the best MBTI experience.',
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

  Widget _buildCurrentLanguagePreview() {
    final currentLang = _availableLanguages.firstWhere(
      (lang) => lang['name'] == _selectedLanguage,
      orElse: () => _availableLanguages.first,
    );

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
                Icons.language,
                color: AppColors.primary,
                size: AppSpacing.iconSize,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Current Language',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Text(
                  currentLang['flag'] as String,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLang['name'] as String,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      currentLang['nativeName'] as String,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: (currentLang['progress'] as int) / 100,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.success,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${currentLang['progress']}%',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelectionSection() {
    return _buildLanguageSection(
      title: 'Language Selection',
      icon: Icons.translate,
      color: AppColors.diplomat,
      description: 'Choose your preferred language for the app interface',
      children: [
        _buildSwitchTile(
          title: 'Use System Language',
          subtitle: 'Follow device language settings',
          value: _useSystemLanguage,
          onChanged: (value) => setState(() => _useSystemLanguage = value),
          icon: Icons.settings,
        ),
        if (!_useSystemLanguage) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Available Languages',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ..._availableLanguages.map((language) {
            return _buildLanguageTile(language);
          }),
        ],
      ],
    );
  }

  Widget _buildLocalizationSection() {
    return _buildLanguageSection(
      title: 'Regional Settings',
      icon: Icons.public,
      color: AppColors.explorer,
      description: 'Customize date, time, and number formats',
      children: [
        _buildDropdownTile(
          title: 'Date Format',
          subtitle: 'How dates are displayed',
          value: _dateFormat,
          options: _dateFormatOptions,
          onChanged: (value) => setState(() => _dateFormat = value!),
          icon: Icons.calendar_today,
          example: _getDateExample(_dateFormat),
        ),
        _buildDropdownTile(
          title: 'Time Format',
          subtitle: 'How time is displayed',
          value: _timeFormat,
          options: _timeFormatOptions,
          onChanged: (value) => setState(() => _timeFormat = value!),
          icon: Icons.access_time,
          example: _getTimeExample(_timeFormat),
        ),
        _buildDropdownTile(
          title: 'Number Format',
          subtitle: 'How numbers are displayed',
          value: _numberFormat,
          options: _numberFormatOptions,
          onChanged: (value) => setState(() => _numberFormat = value!),
          icon: Icons.numbers,
          example: 'e.g. $_numberFormat',
        ),
        _buildDropdownTile(
          title: 'Currency Format',
          subtitle: 'How currency is displayed',
          value: _currencyFormat,
          options: _currencyFormatOptions,
          onChanged: (value) => setState(() => _currencyFormat = value!),
          icon: Icons.attach_money,
          example: _getCurrencyExample(_currencyFormat),
        ),
        _buildSwitchTile(
          title: 'Use Metric Units',
          subtitle: 'Use metric system for measurements',
          value: _useMetricUnits,
          onChanged: (value) => setState(() => _useMetricUnits = value),
          icon: Icons.straighten,
        ),
      ],
    );
  }

  Widget _buildMBTIContentSection() {
    return _buildLanguageSection(
      title: 'MBTI Content',
      icon: Icons.psychology,
      color: AppColors.analyst,
      description: 'Customize MBTI-specific content language preferences',
      children: [
        _buildSwitchTile(
          title: 'Translate MBTI Content',
          subtitle: 'Translate personality descriptions and insights',
          value: _translateMbtiContent,
          onChanged: (value) => setState(() => _translateMbtiContent = value),
          icon: Icons.translate,
        ),
        _buildSwitchTile(
          title: 'Show Original Terms',
          subtitle:
              'Display original English MBTI terms alongside translations',
          value: _showOriginalTerms,
          onChanged: (value) => setState(() => _showOriginalTerms = value),
          icon: Icons.text_fields,
        ),
        _buildDropdownTile(
          title: 'MBTI Content Language',
          subtitle: 'Language for personality type content',
          value: _mbtiContentLanguage,
          options: _mbtiContentLanguageOptions,
          onChanged: (value) => setState(() => _mbtiContentLanguage = value!),
          icon: Icons.psychology,
          example: _getMBTIContentExample(_mbtiContentLanguage),
        ),
      ],
    );
  }

  Widget _buildLanguageActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveLanguageSettings,
            icon: const Icon(Icons.save),
            label: Text(
              'Save Language Settings',
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
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _downloadLanguagePack,
            icon: const Icon(Icons.download),
            label: Text(
              'Download Language Pack',
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
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          onPressed: _contributeTranslation,
          icon: const Icon(Icons.volunteer_activism),
          label: Text(
            'Help Translate',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection({
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

  Widget _buildLanguageTile(Map<String, dynamic> language) {
    final isSelected = language['name'] == _selectedLanguage;
    final progress = language['progress'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border:
            isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
          child: Center(
            child: Text(
              language['flag'] as String,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                language['name'] as String,
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            if (progress < 100)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getProgressColor(progress).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Text(
                  '$progress%',
                  style: AppTypography.labelSmall.copyWith(
                    color: _getProgressColor(progress),
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              language['nativeName'] as String,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
            if (progress < 100) ...[
              const SizedBox(height: AppSpacing.xs),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getProgressColor(progress),
                ),
              ),
            ],
          ],
        ),
        trailing:
            isSelected
                ? Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: AppSpacing.iconSize,
                )
                : null,
        onTap: () => _selectLanguage(language['name'] as String),
      ),
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
    String? example,
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
          if (example != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              example,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ],
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

  // Helper methods

  String _getCurrentLanguageFlag() {
    final currentLang = _availableLanguages.firstWhere(
      (lang) => lang['name'] == _selectedLanguage,
      orElse: () => _availableLanguages.first,
    );
    return currentLang['flag'] as String;
  }

  Color _getProgressColor(int progress) {
    if (progress >= 90) return AppColors.success;
    if (progress >= 70) return AppColors.warning;
    return AppColors.error;
  }

  String _getDateExample(String format) {
    final now = DateTime.now();
    switch (format) {
      case 'MM/DD/YYYY':
        return 'e.g. ${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}';
      case 'DD/MM/YYYY':
        return 'e.g. ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
      case 'YYYY-MM-DD':
        return 'e.g. ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      case 'DD MMM YYYY':
        return 'e.g. ${now.day} Dec ${now.year}';
      case 'MMM DD, YYYY':
        return 'e.g. Dec ${now.day}, ${now.year}';
      default:
        return 'e.g. $format';
    }
  }

  String _getTimeExample(String format) {
    switch (format) {
      case '12-hour':
        return 'e.g. 2:30 PM';
      case '24-hour':
        return 'e.g. 14:30';
      default:
        return 'e.g. $format';
    }
  }

  String _getCurrencyExample(String format) {
    switch (format) {
      case 'USD (\$)':
        return 'e.g. \$99.99';
      case 'EUR (€)':
        return 'e.g. €99.99';
      case 'GBP (£)':
        return 'e.g. £99.99';
      case 'JPY (¥)':
        return 'e.g. ¥9999';
      case 'CNY (¥)':
        return 'e.g. ¥99.99';
      case 'KRW (₩)':
        return 'e.g. ₩99,999';
      default:
        return 'e.g. $format';
    }
  }

  String _getMBTIContentExample(String option) {
    switch (option) {
      case 'Auto':
        return 'Follows app language';
      case 'English Only':
        return 'Always in English';
      case 'Native Language':
        return 'In selected language';
      case 'Both Languages':
        return 'English + Native';
      default:
        return '';
    }
  }

  void _selectLanguage(String languageName) {
    setState(() {
      _selectedLanguage = languageName;
      final selectedLang = _availableLanguages.firstWhere(
        (lang) => lang['name'] == languageName,
      );
      _selectedRegion = selectedLang['region'] as String;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Language changed to $languageName',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _saveLanguageSettings() {
    // Save language settings to SharedPreferences or similar
    print('💾 Saving language settings:');
    print('   Language: $_selectedLanguage');
    print('   Region: $_selectedRegion');
    print('   Date Format: $_dateFormat');
    print('   Time Format: $_timeFormat');
    print('   Use System Language: $_useSystemLanguage');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Language settings saved successfully!',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _downloadLanguagePack() {
    final currentLang = _availableLanguages.firstWhere(
      (lang) => lang['name'] == _selectedLanguage,
      orElse: () => _availableLanguages.first,
    );

    if ((currentLang['progress'] as int) >= 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Language pack already complete!',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textInverse,
              letterSpacing: 0.3,
            ),
          ),
          backgroundColor: AppColors.info,
        ),
      );
      return;
    }

    print('📥 Downloading language pack for $_selectedLanguage...');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Downloading language pack for $_selectedLanguage...',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _contributeTranslation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Translation contribution portal coming soon!',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textInverse,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: AppColors.diplomat,
      ),
    );
  }
}
