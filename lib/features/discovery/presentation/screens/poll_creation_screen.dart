import 'package:flutter/material.dart';
import 'package:opop/core/constants/app_colors.dart';
import 'package:opop/core/constants/app_spacing.dart';
import 'package:opop/core/constants/app_typography.dart';
import 'package:opop/features/discovery/data/models/poll_data.dart';
import 'package:opop/features/discovery/provider/discovery_provider.dart';
import 'package:provider/provider.dart';

class PollCreationScreen extends StatefulWidget {
  const PollCreationScreen({super.key});

  @override
  State<PollCreationScreen> createState() => _PollCreationScreenState();
}

class _PollCreationScreenState extends State<PollCreationScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  final List<FocusNode> _focusNodes = [];

  int _durationHours = PollData.defaultDurationHours;
  bool _allowMultipleSelection = false;
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();
    _initializeOptions();
  }

  void _initializeOptions() {
    for (int i = 0; i < 2; i++) {
      _optionControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
        ),
        title: Text(
          'Create Poll',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isFormValid ? _createPoll : null,
            child: Text(
              'Create',
              style: AppTypography.titleMedium.copyWith(
                color: _isFormValid
                    ? AppColors.primary
                    : AppColors.textDisabled,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Input
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _questionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'What\'s your biggest MBTI strength?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.md),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    style: AppTypography.bodyMedium,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Poll Options
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Options',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_optionControllers.length < 6)
                        TextButton.icon(
                          onPressed: _addOption,
                          icon: const Icon(Icons.add, size: 20),
                          label: Text(
                            'Add Option',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ..._buildOptionFields(),
                ],
              ),
            ),

            const Divider(height: 1),

            // Poll Settings
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Duration
                  _buildDurationSelector(),
                  const SizedBox(height: AppSpacing.md),

                  // Multiple Selection
                  _buildSettingToggle(
                    title: 'Allow multiple selection',
                    subtitle: 'Users can select more than one option',
                    value: _allowMultipleSelection,
                    onChanged: (value) {
                      setState(() {
                        _allowMultipleSelection = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Anonymous Poll
                  _buildSettingToggle(
                    title: 'Anonymous poll',
                    subtitle: 'Hide voter identities from results',
                    value: _isAnonymous,
                    onChanged: (value) {
                      setState(() {
                        _isAnonymous = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Poll Preview
            if (_questionController.text.isNotEmpty) _buildPollPreview(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptionFields() {
    return List.generate(_optionControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, etc.
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _optionControllers[index],
                focusNode: _focusNodes[index],
                decoration: InputDecoration(
                  hintText: 'Option ${String.fromCharCode(65 + index)}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  suffixIcon: _optionControllers.length > 2
                      ? IconButton(
                          onPressed: () => _removeOption(index),
                          icon: const Icon(Icons.close, size: 20),
                          color: AppColors.error,
                        )
                      : null,
                ),
                style: AppTypography.bodyMedium,
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _durationHours.toDouble(),
                min: PollData.minDurationHours.toDouble(),
                max: PollData.maxDurationHours.toDouble(),
                divisions: PollData.maxDurationHours - 1,
                label: PollData.formatDuration(_durationHours),
                activeColor: AppColors.primary,
                inactiveColor: AppColors.textDisabled,
                onChanged: (value) {
                  setState(() {
                    _durationHours = value.toInt();
                  });
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              child: Text(
                PollData.formatDuration(_durationHours),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildPollPreview() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        border: Border.all(color: AppColors.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.poll,
                color: AppColors.primary,
                size: AppSpacing.iconSize,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Poll Preview',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Question
          Text(
            _questionController.text,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Options
          ..._optionControllers.where((c) => c.text.isNotEmpty).map((
            controller,
          ) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: _allowMultipleSelection
                            ? BoxShape.rectangle
                            : BoxShape.circle,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: _allowMultipleSelection
                            ? BorderRadius.circular(AppSpacing.xs)
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        controller.text,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: AppSpacing.sm),

          // Duration Info
          Row(
            children: [
              Icon(Icons.access_time, color: AppColors.textSecondary, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Duration: ${PollData.formatDuration(_durationHours)}',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              if (_allowMultipleSelection)
                Icon(Icons.check_box, color: AppColors.textSecondary, size: 16),
              if (_isAnonymous)
                Icon(
                  Icons.visibility_off,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _addOption() {
    if (_optionControllers.length >= PollData.maxOptions) return;

    setState(() {
      _optionControllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    });

    // Focus on the new option
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNodes.last.requestFocus();
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= PollData.minOptions) return;

    setState(() {
      _optionControllers[index].dispose();
      _focusNodes[index].dispose();
      _optionControllers.removeAt(index);
      _focusNodes.removeAt(index);
    });
  }

  bool get _isFormValid {
    if (_questionController.text.trim().isEmpty) return false;

    final validOptions = _optionControllers
        .where((c) => c.text.trim().isNotEmpty)
        .length;

    return validOptions >= PollData.minOptions;
  }

  void _createPoll() async {
    if (!_isFormValid) return;

    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Creating your MBTI poll...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Use discovery provider to create poll story
    final provider = Provider.of<DiscoveryProvider>(context, listen: false);
    final success = await provider.createPollStory(
      title: 'MBTI Poll',
      question: _questionController.text,
      options: _optionControllers
          .where((c) => c.text.trim().isNotEmpty)
          .map((c) => c.text.trim())
          .toList(),
      durationHours: _durationHours,
      allowMultipleSelection: _allowMultipleSelection,
      isAnonymous: _isAnonymous,
    );

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Poll created successfully! 📊'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate back
      Navigator.pop(context, provider.lastCreatedStory);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create poll: ${provider.createStoryError}'),
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
