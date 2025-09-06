# Network Error Troubleshooting Guide

## 🔧 **Issues Fixed**

### 1. ✅ Platform-Aware URL Configuration

The app now automatically detects your platform and uses the correct URL:

- **Web**: `http://localhost:3000`
- **Android Emulator**: `http://10.0.2.2:3000`
- **iOS Simulator**: `http://localhost:3000`
- **Desktop**: `http://localhost:3000`

### 2. ✅ Connection Testing

- Added `testConnection()` method to verify backend connectivity
- Both login and register screens now test connection before attempting authentication
- Clear error messages when backend is unreachable

### 3. ✅ Improved Error Handling

- Added 10-second timeouts to prevent hanging requests
- Better error messages with specific guidance
- Debug logging to track request/response flow

## 🚀 **How to Test**

### Step 1: Start Backend Server

```bash
cd "C:\Users\me\Desktop\homework\APP\chat_app_backend"
npm run start:dev
```

### Step 2: Verify Backend is Running

Open browser and go to: `http://localhost:3000`
You should see a response (even if it's an error page - that means server is running)

### Step 3: Test Flutter App

The app will now:

1. **Test Connection First**: Before login/register
2. **Show Clear Errors**: If backend is unreachable
3. **Work Cross-Platform**: Automatically uses correct URL

## 🔍 **Debugging Steps**

### If You Still Get Network Errors:

#### 1. Check Backend Status

```powershell
# Test if backend is running
Invoke-WebRequest -Uri "http://localhost:3000" -Method GET
```

#### 2. Check Platform

- **Web/Desktop**: Use `http://localhost:3000`
- **Android**: Use `http://10.0.2.2:3000`
- **iOS**: Use `http://localhost:3000`

#### 3. Check Logs

Look for these debug messages in Flutter console:

```
Testing connection to: http://localhost:3000
Connection test response: 404
Attempting login with: user@example.com
Login response status: 201
```

#### 4. Common Issues & Solutions

**❌ "Connection refused"**

- Backend not running → Start with `npm run start:dev`

**❌ "Connection timeout"**

- Firewall blocking → Check Windows Firewall
- Wrong URL → Verify platform-specific URL

**❌ "Cannot connect to server"**

- Backend crashed → Check backend console for errors
- Port already in use → Kill process on port 3000

## 📱 **Platform-Specific Notes**

### Android Emulator

- Uses `10.0.2.2:3000` (special localhost mapping)
- Requires internet permission (already added)
- Allows cleartext traffic (already configured)

### Web

- Uses `localhost:3000` directly
- May need CORS configuration on backend
- Check browser developer tools for errors

### iOS Simulator

- Uses `localhost:3000` like desktop
- Should work same as web platform

### Desktop (Windows/macOS/Linux)

- Uses `localhost:3000` directly
- Most straightforward platform

## 🎯 **Quick Test Commands**

```powershell
# Check if backend is responding
curl http://localhost:3000

# Test registration endpoint
Invoke-WebRequest -Uri "http://localhost:3000/auth/register" -Method POST -ContentType "application/json" -Body '{"email":"test@test.com","password":"test123"}'

# Test login endpoint
Invoke-WebRequest -Uri "http://localhost:3000/auth/login" -Method POST -ContentType "application/json" -Body '{"email":"test@test.com","password":"test123"}'
```

## ✅ **Success Indicators**

When everything is working, you should see:

1. **Connection Test**: `Connection test response: 404` (404 is fine - means server responds)
2. **Registration**: `Registration response status: 201`
3. **Login**: `Login response status: 201`
4. **Success Message**: "Welcome back, [Username]!"
5. **Navigation**: Smooth transition to Home screen

## 🆘 **Still Having Issues?**

If you're still getting network errors:

1. Check the debug console output
2. Verify backend is running on port 3000
3. Try testing the backend endpoints directly
4. Check if antivirus/firewall is blocking connections
5. Restart both backend and Flutter app

The app now has comprehensive error handling and should give you clear messages about what's wrong!
