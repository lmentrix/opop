import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Advanced MBTI-themed pull-to-refresh animation with personality insights
class MBTIPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final double displacement;

  const MBTIPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.displacement = 60.0,
  });

  @override
  State<MBTIPullToRefresh> createState() => _MBTIPullToRefreshState();
}

class _MBTIPullToRefreshState extends State<MBTIPullToRefresh>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late AnimationController _fadeController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  bool _isRefreshing = false;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Start animations
    _rotationController.repeat();
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    _fadeController.forward();

    try {
      await widget.onRefresh();
    } finally {
      // Stop animations
      _rotationController.stop();
      _rotationController.reset();
      _bounceController.reset();
      _fadeController.reset();

      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (notification.metrics.outOfRange &&
              notification.metrics.extentBefore < 0) {
            setState(() {
              _dragOffset = notification.metrics.extentBefore.abs();
            });
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        strokeWidth: 3,
        displacement: widget.displacement,
        child: Column(
          children: [
            if (_dragOffset > 0 && !_isRefreshing) _buildRefreshHeader(),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }

  Widget _buildRefreshHeader() {
    final progress = (_dragOffset / widget.displacement).clamp(0.0, 1.0);

    return Container(
      height: widget.displacement,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated MBTI personality icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedIcon(
                Icons.psychology,
                AppColors.diplomat,
                progress,
                0,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildAnimatedIcon(
                Icons.auto_awesome,
                AppColors.primary,
                progress,
                1,
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildAnimatedIcon(
                Icons.chat_bubble,
                AppColors.analyst,
                progress,
                2,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Dynamic refresh messages
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: progress > 0.3 ? 1.0 : 0.0,
            child: Text(
              _getRefreshMessage(progress),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Progress indicator
          if (progress > 0.5)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceVariant.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 3,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(
    IconData icon,
    Color color,
    double progress,
    int index,
  ) {
    final delay = index * 0.1;
    final adjustedProgress = (progress - delay).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale:
              0.8 +
              (adjustedProgress * 0.4 * (1 + _bounceAnimation.value * 0.2)),
          child: Transform.rotate(
            angle: adjustedProgress * 3.14159 * 2 * _rotationAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8 * adjustedProgress,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.textInverse, size: 16),
            ),
          ),
        );
      },
    );
  }

  String _getRefreshMessage(double progress) {
    if (progress < 0.3) {
      return 'Pull to refresh...';
    } else if (progress < 0.6) {
      return 'Loading new insights...';
    } else if (progress < 0.9) {
      return 'Almost there...';
    } else {
      return 'Release to refresh!';
    }
  }
}

/// MBTI personality type refresh indicator
class MBTIPersonalityRefresh extends StatelessWidget {
  final String mbtiType;
  final double progress;

  const MBTIPersonalityRefresh({
    super.key,
    required this.mbtiType,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final personalityData = _getPersonalityData(mbtiType);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: personalityData['colors'] as List<Color>,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            mbtiType,
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textInverse,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            personalityData['trait'] as String,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textInverse.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getPersonalityData(String mbtiType) {
    switch (mbtiType) {
      case 'ENFP':
        return {
          'colors': [AppColors.diplomat, AppColors.diplomat.withOpacity(0.7)],
          'trait': 'The Campaigner - Enthusiastic and creative',
        };
      case 'INFJ':
        return {
          'colors': [AppColors.diplomat, AppColors.primary],
          'trait': 'The Advocate - Insightful and inspiring',
        };
      case 'INTJ':
        return {
          'colors': [AppColors.analyst, AppColors.analyst.withOpacity(0.7)],
          'trait': 'The Architect - Strategic and imaginative',
        };
      case 'ENTP':
        return {
          'colors': [AppColors.analyst, AppColors.diplomat],
          'trait': 'The Debater - Innovative and curious',
        };
      default:
        return {
          'colors': [AppColors.primary, AppColors.primary.withOpacity(0.7)],
          'trait': 'Unique personality with special insights',
        };
    }
  }
}
