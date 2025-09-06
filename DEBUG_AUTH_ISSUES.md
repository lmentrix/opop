# Authentication Debug Guide

## Issues Fixed

### 1. ✅ User Model ID Type Mismatch

**Problem**: Backend returns string ID (CUID), but Flutter expected integer
**Fix**: Changed User model `id` field from `int` to `String`

### 2. ✅ Android Network Permissions

**Problem**: Android apps need explicit permissions for HTTP requests
**Fix**: Added to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
android:usesCleartextTraffic="true"
```

### 3. ✅ Android Emulator Network Access

**Problem**: `localhost:3000` doesn't work in Android emulator
**Fix**: Changed base URL to `http://10.0.2.2:3000` (Android emulator's localhost mapping)

### 4. ✅ Debug Logging Added

**Fix**: Added comprehensive logging in AuthService to track requests and responses

## Current Configuration

### Base URL

- **Android Emulator**: `http://10.0.2.2:3000`
- **iOS Simulator**: `http://localhost:3000` (change if needed)
- **Real Device**: Use your computer's IP address (e.g., `http://192.168.1.100:3000`)

### Backend Status

✅ Backend is running and responding correctly
✅ Register endpoint returns 201 status
✅ Response structure matches Flutter models

## Debugging Steps

### Step 1: Check Backend Connection

Make sure your NestJS backend is running:

```bash
cd chat_app_backend
npm run start:dev
```

### Step 2: Run Flutter App with Debug Logs

```bash
flutter run
```

Look for these debug messages in the console:

- `Attempting registration with: user@example.com`
- `Registration response status: 201`
- `Registration response body: {...}`
- `Attempting login with: user@example.com`
- `Login response status: 200`

### Step 3: Test Different Platforms

#### Android Emulator

- Base URL: `http://10.0.2.2:3000` ✅ (already configured)
- Should work out of the box

#### iOS Simulator

If you're testing on iOS, change the base URL:

```dart
static const String _baseUrl = 'http://localhost:3000';
```

#### Real Device

If testing on a real device, use your computer's IP:

```dart
static const String _baseUrl = 'http://YOUR_COMPUTER_IP:3000';
```

Find your IP with: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)

## Common Error Messages & Solutions

### "Network error: SocketException"

**Cause**: Can't reach backend server
**Solutions**:

1. Check backend is running on port 3000
2. Verify correct IP address for your platform
3. Check firewall settings

### "FormatException: Unexpected character"

**Cause**: Response parsing error
**Solutions**:

1. Check debug logs for actual response body
2. Verify response structure matches models

### "type 'int' is not a subtype of type 'String'"

**Cause**: Data type mismatch in models
**Solutions**:

1. Check User model matches backend response
2. Verify all field types are correct

## Testing Authentication

### Test Registration

1. Open Flutter app
2. Navigate to register screen
3. Enter: `test@example.com` / `password123`
4. Check console logs for request/response
5. Should see success message and redirect to login

### Test Login

1. Use the same credentials from registration
2. Check console logs for request/response
3. Should see success message and redirect to main app

### Test Token Storage

1. After successful login, close and reopen app
2. Should automatically navigate to main app (bypassing login)

## Advanced Debugging

### Enable Network Logging

Add to `main.dart` for detailed HTTP logs:

```dart
import 'dart:developer' as developer;

void main() {
  // Enable HTTP logging
  developer.log('Starting app with debug mode');
  runApp(const MyApp());
}
```

### Check SharedPreferences

Add debugging to check token storage:

```dart
// In AuthService, add this method:
Future<void> debugTokenStorage() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString(_tokenKey);
  final user = prefs.getString(_userKey);
  print('Stored token: $token');
  print('Stored user: $user');
}
```

## Next Steps

1. **Run the app** and check console logs
2. **Try registration** with a new email
3. **Try login** with registered credentials
4. **Report specific error messages** if issues persist

The authentication system is now properly configured and should work with your NestJS backend!
