import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Personality card widget for displaying MBTI information
class PersonalityCard extends StatelessWidget {
  final String mbtiType;
  final String description;
  final List<String> strengths;
  final List<String> weaknesses;

  const PersonalityCard({
    super.key,
    required this.mbtiType,
    required this.description,
    required this.strengths,
    required this.weaknesses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMbtiHeader(),
        const SizedBox(height: AppSpacing.lg),
        _buildDescription(),
        const SizedBox(height: AppSpacing.lg),
        _buildStrengthsAndWeaknesses(),
      ],
    );
  }

  Widget _buildMbtiHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.analyst, AppColors.analyst.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.analyst.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.textInverse.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: Icon(
              Icons.psychology,
              color: AppColors.textInverse,
              size: AppSpacing.iconSize * 1.5,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mbtiType,
                  style: AppTypography.displaySmall.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.0,
                  ),
                ),
                Text(
                  _getPersonalityNickname(mbtiType),
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textInverse.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.analyst.withOpacity(0.2)),
      ),
      child: Text(
        description,
        style: AppTypography.bodyLarge.copyWith(
          color: AppColors.textPrimary,
          height: 1.6,
          letterSpacing: 0.3,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildStrengthsAndWeaknesses() {
    return Row(
      children: [
        Expanded(
          child: _buildTraitColumn(
            title: 'STRENGTHS',
            traits: strengths,
            color: AppColors.success,
            icon: Icons.trending_up,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildTraitColumn(
            title: 'WEAKNESSES',
            traits: weaknesses,
            color: AppColors.warning,
            icon: Icons.trending_down,
          ),
        ),
      ],
    );
  }

  Widget _buildTraitColumn({
    required String title,
    required List<String> traits,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSize),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: AppTypography.labelLarge.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...traits.map((trait) => _buildTraitItem(trait, color)),
        ],
      ),
    );
  }

  Widget _buildTraitItem(String trait, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpacing.full),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              trait,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPersonalityNickname(String mbtiType) {
    switch (mbtiType) {
      case 'INTJ':
        return 'The Architect';
      case 'INTP':
        return 'The Logician';
      case 'ENTJ':
        return 'The Commander';
      case 'ENTP':
        return 'The Debater';
      case 'INFJ':
        return 'The Advocate';
      case 'INFP':
        return 'The Mediator';
      case 'ENFJ':
        return 'The Protagonist';
      case 'ENFP':
        return 'The Campaigner';
      case 'ISTJ':
        return 'The Logistician';
      case 'ISFJ':
        return 'The Defender';
      case 'ESTJ':
        return 'The Executive';
      case 'ESFJ':
        return 'The Consul';
      case 'ISTP':
        return 'The Virtuoso';
      case 'ISFP':
        return 'The Adventurer';
      case 'ESTP':
        return 'The Entrepreneur';
      case 'ESFP':
        return 'The Entertainer';
      default:
        return 'The Explorer';
    }
  }
}
