import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/models/chat_conversation.dart';

/// Filter chips widget for filtering conversations by type
class ChatFilterChips extends StatelessWidget {
  final ConversationType? selectedFilter;
  final Function(ConversationType?) onFilterChanged;

  const ChatFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All',
            isSelected: selectedFilter == null,
            onTap: () => onFilterChanged(null),
          ),
          ...ConversationType.values.map(
            (type) => _buildFilterChip(
              label: _getFilterLabel(type),
              isSelected: selectedFilter == type,
              onTap: () => onFilterChanged(type),
              color: _getFilterColor(type),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.textInverse : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: color ?? AppColors.primary,
        checkmarkColor: AppColors.textInverse,
        side: BorderSide(
          color:
              isSelected
                  ? (color ?? AppColors.primary)
                  : AppColors.outline.withOpacity(0.3),
          width: 1,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.full),
        ),
      ),
    );
  }

  String _getFilterLabel(ConversationType type) {
    switch (type) {
      case ConversationType.assessment:
        return 'Assessment';
      case ConversationType.personality:
        return 'Personality';
      case ConversationType.support:
        return 'Support';
      case ConversationType.group:
        return 'Groups';
      case ConversationType.system:
        return 'System';
      default:
        return 'Personal';
    }
  }

  Color _getFilterColor(ConversationType type) {
    switch (type) {
      case ConversationType.assessment:
        return AppColors.analyst;
      case ConversationType.personality:
        return AppColors.diplomat;
      case ConversationType.support:
        return AppColors.sentinel;
      case ConversationType.group:
        return AppColors.explorer;
      case ConversationType.system:
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }
}
