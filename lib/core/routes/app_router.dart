// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Auth screens
import 'package:opop/features/auth/presentation/screens/login_screen.dart';
import 'package:opop/features/auth/presentation/screens/register_screen.dart';
import 'package:opop/features/chat/data/datasources/chat_dummy_data.dart';
// Chat screens
import 'package:opop/features/chat/presentation/screens/chat_detail_screen.dart';
import 'package:opop/features/chat/presentation/screens/chat_list_screen.dart';
// Discovery screens
import 'package:opop/features/discovery/presentation/screens/discovery_screen.dart';
// Friends screens
import 'package:opop/features/friends/presentation/screens/friends_screen.dart';
// Home screens
import 'package:opop/features/home/presentation/screens/home_screen.dart';
// Other screens
import 'package:opop/features/matching/presentation/screens/matching_screen.dart';
// Navigation screens
import 'package:opop/features/navigation/presentation/screens/main_navigation_screen.dart';
// Profile screens
import 'package:opop/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:opop/features/profile/presentation/screens/friend_profile_screen.dart';
import 'package:opop/features/profile/presentation/screens/user_profile_screen.dart';
// Settings screens
import 'package:opop/features/settings/presentation/screens/about_screen.dart';
import 'package:opop/features/settings/presentation/screens/accessibility_screen.dart';
import 'package:opop/features/settings/presentation/screens/language_screen.dart';
import 'package:opop/features/settings/presentation/screens/notification_demo_screen.dart';
import 'package:opop/features/settings/presentation/screens/notifications_screen.dart';
import 'package:opop/features/settings/presentation/screens/privacy_screen.dart';
import 'package:opop/features/settings/presentation/screens/settings_screen.dart';
import 'package:opop/features/settings/presentation/screens/signout_screen.dart';
import 'package:opop/features/settings/presentation/screens/support_screen.dart';
import 'package:opop/features/settings/presentation/screens/theme_screen.dart';
// Splash screens
import 'package:opop/features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      // Authentication routes
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterScreen();
        },
      ),

      // Main navigation route
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (BuildContext context, GoRouterState state) {
          return const MainNavigationScreen();
        },
        routes: [
          // Home tab
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen();
            },
          ),

          // Chat routes
          GoRoute(
            path: '/chat',
            name: 'chat-list',
            builder: (BuildContext context, GoRouterState state) {
              return const ChatListScreen();
            },
          ),
          GoRoute(
            path: '/chat/:id',
            name: 'chat-detail',
            builder: (BuildContext context, GoRouterState state) {
              final String chatId = state.pathParameters['id']!;
              return ChatDetailWrapper(chatId: chatId);
            },
          ),

          // Discovery routes
          GoRoute(
            path: '/discovery',
            name: 'discovery',
            builder: (BuildContext context, GoRouterState state) {
              return const DiscoveryScreen();
            },
          ),

          // Friends routes
          GoRoute(
            path: '/friends',
            name: 'friends',
            builder: (BuildContext context, GoRouterState state) {
              return const FriendsScreen();
            },
          ),

          // Profile routes
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const UserProfileScreen();
            },
          ),
          GoRoute(
            path: '/profile/edit',
            name: 'edit-profile',
            builder: (BuildContext context, GoRouterState state) {
              return const EditProfileScreen();
            },
          ),

          // Matching routes
          GoRoute(
            path: '/matching',
            name: 'matching',
            builder: (BuildContext context, GoRouterState state) {
              return const MatchingScreen();
            },
          ),

          // Other routes
          GoRoute(
            path: '/friendprofile',
            name: 'friend-profile',
            builder: (BuildContext context, GoRouterState state) {
              return const FriendProfileScreen();
            },
          ),

          // Settings routes
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (BuildContext context, GoRouterState state) {
              return const SettingsScreen();
            },
            routes: [
              GoRoute(
                path: '/theme',
                name: 'theme',
                builder: (BuildContext context, GoRouterState state) {
                  return const ThemeScreen();
                },
              ),
              GoRoute(
                path: '/notifications',
                name: 'notifications',
                builder: (BuildContext context, GoRouterState state) {
                  return const NotificationsScreen();
                },
              ),
              GoRoute(
                path: '/notification-demo',
                name: 'notification-demo',
                builder: (BuildContext context, GoRouterState state) {
                  return const NotificationDemoScreen();
                },
              ),
              GoRoute(
                path: '/language',
                name: 'language',
                builder: (BuildContext context, GoRouterState state) {
                  return const LanguageScreen();
                },
              ),
              GoRoute(
                path: '/accessibility',
                name: 'accessibility',
                builder: (BuildContext context, GoRouterState state) {
                  return const AccessibilityScreen();
                },
              ),
              GoRoute(
                path: '/privacy',
                name: 'privacy',
                builder: (BuildContext context, GoRouterState state) {
                  return const PrivacyScreen();
                },
              ),
              GoRoute(
                path: '/support',
                name: 'support',
                builder: (BuildContext context, GoRouterState state) {
                  return const SupportScreen();
                },
              ),
              GoRoute(
                path: '/about',
                name: 'about',
                builder: (BuildContext context, GoRouterState state) {
                  return const AboutScreen();
                },
              ),
              GoRoute(
                path: '/signout',
                name: 'signout',
                builder: (BuildContext context, GoRouterState state) {
                  return const SignoutScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${state.path}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/splash'),
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
    // Optional: Redirect logic
    redirect: (BuildContext context, GoRouterState state) {
      // Add your authentication or other redirect logic here
      // Example implementation:
      // final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // final isLoggedIn = authProvider.isAuthenticated;
      // final isAuthRoute = state.location.startsWith('/login') ||
      //                      state.location.startsWith('/register') ||
      //                      state.location == '/splash';
      //
      // if (!isLoggedIn && !isAuthRoute) {
      //   return '/login';
      // }
      //
      // if (isLoggedIn && isAuthRoute) {
      //   return '/main/home';
      // }
      return null; // No redirect
    },
  );
}

// Navigation helper methods
class AppRoutes {
  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // Main app routes
  static const String main = '/main';
  static const String home = '/main/home';
  static const String chatList = '/main/chat';
  static const String discovery = '/main/discovery';
  static const String friends = '/main/friends';
  static const String profile = '/main/profile';
  static const String editProfile = '/main/profile/edit';
  static const String matching = '/main/matching';

  // Settings routes
  static const String settings = '/main/settings';
  static const String theme = '/main/settings/theme';
  static const String notifications = '/main/settings/notifications';
  static const String notificationDemo = '/main/settings/notification-demo';
  static const String language = '/main/settings/language';
  static const String accessibility = '/main/settings/accessibility';
  static const String privacy = '/main/settings/privacy';
  static const String support = '/main/settings/support';
  static const String about = '/main/settings/about';
  static const String signout = '/main/settings/signout';

  // Dynamic routes
  static String chatDetail(String id) => '/main/chat/$id';
  static String userProfile(String id) => '/main/profile/$id';
}

// Wrapper screen for chat detail navigation
class ChatDetailWrapper extends StatelessWidget {
  final String chatId;

  const ChatDetailWrapper({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    // Find the conversation by ID from dummy data
    final conversations = ChatDummyData.getConversations();
    final conversation = conversations.firstWhere(
      (conv) => conv.id == chatId,
      orElse: () => conversations.first, // Fallback to first conversation
    );

    return ChatDetailScreen(conversation: conversation);
  }
}
