# Authentication Implementation

This document outlines the authentication system implemented in the OPOP Flutter application.

## Features Implemented

### 1. Authentication Models

- **User Model** (`lib/core/models/user.dart`): Represents user data from backend
- **AuthRequest Models** (`lib/core/models/auth_request.dart`): Login and Register request DTOs
- **AuthResponse Models** (`lib/core/models/auth_response.dart`): Authentication response models

### 2. Authentication Service

- **AuthService** (`lib/core/services/auth_service.dart`): Handles all authentication operations
  - User registration
  - User login
  - Token management with SharedPreferences
  - Authentication state checking
  - Logout functionality
  - Input validation (email format, password strength)

### 3. Authentication Screens

- **LoginScreen** (`lib/features/auth/presentation/screens/login_screen.dart`): User login interface
- **RegisterScreen** (`lib/features/auth/presentation/screens/register_screen.dart`): User registration interface

### 4. Splash Screen Integration

- **Updated SplashScreen** (`lib/features/splash/presentation/screens/splash_screen.dart`):
  - Checks authentication state on app launch
  - Navigates to MainNavigationScreen if authenticated
  - Navigates to LoginScreen if not authenticated

### 5. Logout Functionality

- **Updated SignoutScreen** (`lib/features/settings/presentation/screens/signout_screen.dart`):
  - Integrated with AuthService for proper logout
  - Clears stored authentication data
  - Navigates back to login screen

## Backend Integration

The authentication service is configured to work with the NestJS backend:

### API Endpoints

- **POST** `/auth/register` - User registration
- **POST** `/auth/login` - User login

### Configuration

- Base URL: `http://localhost:3000` (update in `AuthService` for production)
- Authentication uses JWT tokens
- Tokens stored securely using SharedPreferences

## Usage Flow

1. **App Launch**: SplashScreen checks authentication state
2. **First Time Users**: Directed to LoginScreen → can navigate to RegisterScreen
3. **Registration**: User creates account → redirected to LoginScreen
4. **Login**: User authenticates → redirected to MainNavigationScreen
5. **Authenticated Users**: Direct access to MainNavigationScreen on subsequent launches
6. **Logout**: Available in settings → clears data and returns to LoginScreen

## Dependencies Added

```yaml
dependencies:
  http: ^1.1.0 # HTTP requests
  shared_preferences: ^2.2.2 # Local storage
```

## Error Handling

- Network errors with user-friendly messages
- Form validation for email format and password requirements
- Authentication failures handled gracefully
- Loading states during API calls

## Security Features

- Passwords are sent securely to backend for hashing
- JWT tokens stored locally for session management
- Automatic token validation on app launch
- Secure logout with complete data cleanup

## Backend Compatibility

This implementation is fully compatible with the provided NestJS backend:

- Matches `CreateUserDto` and `LoginUserDto` structures
- Handles backend response formats correctly
- Supports JWT authentication flow
- Compatible with bcrypt password hashing on backend

## Future Enhancements

- Token refresh mechanism
- Biometric authentication
- Social login integration
- Password reset functionality
- Account verification
