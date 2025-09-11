import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opop/features/auth/preference/auth_preference.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_spacing.dart';

/// Splash screen for MBTI Explorer app
/// Features animated MBTI branding and smooth transition to home
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textSlide;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller (reduced duration)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text animation controller (reduced duration)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Fade animation controller (reduced duration)
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Logo scale and rotation animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Text slide animation
    _textSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
  }

  void _startAnimationSequence() async {
    // Start logo animation
    await _logoController.forward();

    // Start text animation
    await _textController.forward();

    // Start fade animation
    await _fadeController.forward();

    // Reduced wait time before navigation
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      await _checkAuthenticationAndNavigate();
    }
  }

  Future<void> _checkAuthenticationAndNavigate() async {
    try {
      if (mounted) {
        // Add timeout to prevent infinite loading
        final authResult = await Future.any([
          _checkAuthStatus(),
          Future.delayed(const Duration(seconds: 3), () => 'timeout'),
        ]);

        if (authResult == 'timeout') {
          // Timeout occurred, navigate to login
          if (mounted) {
            context.go('/login');
          }
          return;
        }

        // Check if user is logged in
        final isLoggedIn = authResult as bool;

        if (mounted) {
          if (isLoggedIn) {
            context.go('/main'); // Navigate to main app
          } else {
            context.go('/login'); // Navigate to login
          }
        }
      }
    } catch (e) {
      // If there's any error, go to login screen using GoRouter
      if (mounted) {
        context.go('/login');
      }
    }
  }

  Future<bool> _checkAuthStatus() async {
    try {
      final authPreference = AuthPreference();
      // Add timeout to prevent hanging
      final token = await Future.any([
        authPreference.getLoginData(),
        Future.delayed(const Duration(seconds: 2), () => null),
      ]);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and main branding
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo container
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScale.value,
                            child: Transform.rotate(
                              angle: _logoRotation.value * 0.1,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.textInverse,
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.lg,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadow.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.psychology,
                                  size: 60,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // App name with slide animation
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _textSlide.value),
                            child: Text(
                              AppConstants.appName,
                              style: Theme.of(context).textTheme.displayMedium
                                  ?.copyWith(
                                    color: AppColors.textInverse,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Tagline with fade animation
                      AnimatedBuilder(
                        animation: _fadeController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Text(
                              AppConstants.appDescription,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppColors.textInverse.withOpacity(
                                      0.9,
                                    ),
                                    height: 1.5,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom section with MBTI types preview
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Column(
                    children: [
                      // MBTI types preview
                      AnimatedBuilder(
                        animation: _fadeController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildMbtiTypePreview('A', AppColors.analyst),
                                _buildMbtiTypePreview('D', AppColors.diplomat),
                                _buildMbtiTypePreview('S', AppColors.sentinel),
                                _buildMbtiTypePreview('E', AppColors.explorer),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Loading indicator
                      AnimatedBuilder(
                        animation: _fadeController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _fadeAnimation.value,
                            child: Column(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.textInverse,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Discovering your personality...',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textInverse
                                            .withOpacity(0.8),
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMbtiTypePreview(String letter, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textInverse,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
