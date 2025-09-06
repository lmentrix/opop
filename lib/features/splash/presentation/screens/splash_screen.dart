import 'package:flutter/material.dart';
import 'package:opop/features/auth/preference/auth_preference.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../navigation/presentation/screens/main_navigation_screen.dart';

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

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void isLogin() async {
    final _authPreference = AuthPreference();
    final loggedIn = await _authPreference.getLoginData();
    if (loggedIn != null) {
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
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

    // Wait a bit then check authentication and navigate
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      await _checkAuthenticationAndNavigate();
    }
  }

  Future<void> _checkAuthenticationAndNavigate() async {
    try {
      if (mounted) {
        // 1. Instantiate your preference class
        final authPreference = AuthPreference();

        // 2. Check for login data asynchronously
        final loggedInUser = await authPreference.getLoginData();

        // 3. Determine the next screen based on login status
        Widget nextScreen;
        if (loggedInUser != null) {
          // User data exists, they are logged in.
          nextScreen = const MainNavigationScreen();
        } else {
          // No user data, they need to log in.
          nextScreen = const LoginScreen();
        }

        // 4. Navigate with a fade transition (your existing code is perfect)
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    } catch (e) {
      // If there's any error, it's safest to go to the login screen.
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
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
