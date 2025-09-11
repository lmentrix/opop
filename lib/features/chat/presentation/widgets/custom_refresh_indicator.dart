import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';

/// Custom pull-to-refresh indicator with MBTI-themed animations
class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;
  final double displacement;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 3.0,
    this.displacement = 40.0,
  });

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Start animations
    _rotationController.repeat();
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    try {
      await widget.onRefresh();
    } finally {
      // Stop animations
      _rotationController.stop();
      _rotationController.reset();
      _scaleController.reset();

      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: widget.color ?? AppColors.primary,
      backgroundColor: widget.backgroundColor ?? AppColors.surface,
      strokeWidth: widget.strokeWidth,
      displacement: widget.displacement,
      notificationPredicate: (notification) {
        return notification.depth == 0;
      },
      child: widget.child,
    );
  }
}

/// Enhanced refresh indicator with custom animations and MBTI personality quotes
class MBTIRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const MBTIRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      strokeWidth: 3,
      displacement: 40,
      notificationPredicate: (notification) {
        return notification.depth == 0;
      },
      child: child,
    );
  }
}

/// Pull-to-refresh header with animated MBTI personality insights
class RefreshHeader extends StatelessWidget {
  final double progress;
  final bool isRefreshing;

  const RefreshHeader({
    super.key,
    required this.progress,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    final quotes = [
      'Refreshing conversations...',
      'Updating personality insights...',
      'Loading new messages...',
      'Syncing MBTI data...',
      'Discovering new connections...',
    ];

    final currentQuote = quotes[DateTime.now().second % quotes.length];

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated chat bubbles
              ...List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(
                    horizontal: index == 1 ? AppSpacing.xs : AppSpacing.xs / 2,
                  ),
                  child: Transform.scale(
                    scale: isRefreshing
                        ? 1.0 + (0.2 * (index + 1) * progress)
                        : 0.8 + (0.4 * progress * (index + 1) / 3),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primary.withOpacity(0.4),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        index == 0
                            ? Icons.chat
                            : index == 1
                            ? Icons.psychology
                            : Icons.auto_awesome,
                        color: AppColors.textInverse,
                        size: 16,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: progress > 0.5 ? 1.0 : 0.0,
            child: Text(
              currentQuote,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom refresh physics for smoother pull-to-refresh experience
class CustomRefreshPhysics extends ScrollPhysics {
  const CustomRefreshPhysics({super.parent});

  @override
  CustomRefreshPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomRefreshPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Make the pull-to-refresh feel more responsive
    if (position.outOfRange && offset < 0) {
      return offset * 0.8; // Reduce resistance when pulling down
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Custom ballistic simulation for smoother over-scroll
    if (position.outOfRange) {
      final tolerance = this.tolerance;
      if (position.outOfRange == 1.0 && velocity < 0.0) {
        // Overscrolling at the top
        return BouncingScrollSimulation(
          spring: const SpringDescription(
            mass: 1.0,
            stiffness: 200.0,
            damping: 15.0,
          ),
          position: position.pixels,
          velocity: velocity * 0.8, // Dampen the velocity
          leadingExtent: position.minScrollExtent,
          trailingExtent: position.maxScrollExtent,
          tolerance: tolerance,
        );
      }
    }
    return super.createBallisticSimulation(position, velocity);
  }
}
