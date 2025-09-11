# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application called "OPOP" that implements an MBTI personality explorer with chat functionality. The app follows clean architecture principles with feature-based organization.

## Common Development Commands

### Flutter Commands

```bash
# Run the app
flutter run

# Build for release
flutter build apk --release
flutter build ios --release

# Run tests
flutter test

# Lint and analyze
flutter analyze

# Format code
flutter format .

# Clean build cache
flutter clean
flutter pub get
```

### Code Generation

```bash
# Run build runner for JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-generate
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Architecture Overview

### Project Structure

```
lib/
├── core/                    # Core application utilities
│   ├── constants/          # App-wide constants (colors, typography, spacing)
│   ├── models/            # Data models (User, AuthRequest, AuthResponse)
│   ├── services/          # Core services (AuthService, NotificationService)
│   └── themes/            # App themes (light, dark, app theme)
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   ├── chat/              # Chat functionality
│   ├── profile/           # User profile management
│   ├── settings/          # App settings
│   └── splash/            # Splash screen
└── main.dart              # App entry point
```

### Key Features

- **Authentication**: JWT-based auth with NestJS backend integration
- **Profile Management**: User profiles with avatar selection and personality types
- **Chat System**: Real-time messaging with conversation management
- **Theme System**: MBTI-themed color system with light/dark mode support

### State Management

- Uses Provider pattern for state management
- ProfileProvider manages user profile state at the app level
- Each feature can have its own providers/controllers

### Backend Integration

- **Base URLs**: Platform-specific configuration
  - Android Emulator: `http://10.0.2.2:3000`
  - iOS Simulator: `http://localhost:3000`
  - Desktop/Web: `http://localhost:3000`
- **Authentication**: JWT tokens stored in SharedPreferences
- **API Endpoints**: `/auth/register`, `/auth/login`

## Design System

### Theme System

The app uses a comprehensive MBTI-themed design system:

- **Color System**: Personality type-specific gradients (Analysts: Purple, Diplomats: Cyan, Sentinels: Green, Explorers: Amber)
- **Typography**: Consistent text styles across the app
- **Spacing**: 4px-based spacing system
- **Components**: Unified button, card, and input field styles

### Key Constants

- Use `AppColors` for all color references
- Use `AppTypography` for text styles
- Use `AppSpacing` for layout spacing
- Use `AppConstants` for app-wide values

## Development Guidelines

### Code Style

- Follow the existing code structure and naming conventions
- Use snake_case for Dart files
- Group related files with common prefixes
- Implement proper error handling with user-friendly messages

### Feature Implementation

- Follow the clean architecture pattern (data/domain/presentation layers)
- Create separate providers for each feature's state management
- Implement proper loading, error, and success states
- Use the established design system constants

### Authentication Flow

1. **App Launch**: SplashScreen checks authentication state
2. **Unauthenticated**: Navigate to LoginScreen → RegisterScreen option
3. **Authenticated**: Navigate to MainNavigationScreen
4. **Token Storage**: JWT tokens stored in SharedPreferences
5. **Auto-login**: Check stored tokens on app launch

### Testing

- Widget tests for custom widgets
- Unit tests for business logic
- Integration tests for critical user flows
- Use the existing test structure in `test/` directory

## Network Configuration

The app automatically detects the platform and configures the correct backend URL:

- **Android Emulator**: Uses `10.0.2.2:3000` (special localhost mapping)
- **iOS Simulator**: Uses `localhost:3000`
- **Desktop/Web**: Uses `localhost:3000`

For real device testing, update the base URL in `AuthService` to use your computer's IP address.

## Debugging

### Enable Debug Logging

The app includes comprehensive debug logging in AuthService. Look for:

- Connection test results
- Request/response logging
- Authentication state changes

### Common Issues

- **Network Errors**: Check backend is running on port 3000
- **Platform-Specific URLs**: Verify correct URL for your target platform
- **Authentication Issues**: Check debug logs for request/response details
- **Theme Issues**: Verify all constants are imported correctly

## Important Notes

- The app follows a comprehensive design system documented in `rule.md`
- Authentication system is fully implemented with NestJS backend integration
- Network configuration handles multiple platforms automatically
- The MBTI theme system provides personality-specific visual elements
- Always use the provided constants for colors, typography, and spacing
