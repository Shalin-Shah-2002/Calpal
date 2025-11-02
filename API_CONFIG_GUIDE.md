# 🔧 API Configuration Guide

## Current Error Fix

The error you're seeing indicates a connection issue. Here's how to fix it based on your setup:

## ✅ Quick Fix Applied

I've updated the configuration to use **Android Emulator** settings:
- URL: `http://10.0.2.2:8080`
- Endpoint: `/nutritionv`

## 📱 Choose Your Configuration

Edit `lib/app/core/config/app_config.dart` based on where you're running:

### 1️⃣ Android Emulator (Default - Already Set)
```dart
static const String apiBaseUrl = 'http://10.0.2.2:8080';
```
✅ This is now the default setting

### 2️⃣ iOS Simulator
```dart
static const String apiBaseUrl = 'http://localhost:8080';
```

### 3️⃣ Physical Device (iPhone or Android)
```dart
static const String apiBaseUrl = 'http://192.168.x.x:8080';
```
Replace `192.168.x.x` with your computer's local IP address

### 4️⃣ Web Browser
```dart
static const String apiBaseUrl = 'http://localhost:8080';
```

## 🖥️ Find Your Computer's IP Address

### On macOS:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```
Or: System Preferences → Network → Select your connection → IP address

### On Windows:
```bash
ipconfig
```
Look for "IPv4 Address"

### On Linux:
```bash
ip addr show
```
Or: `ifconfig`

## 🚀 Backend Server Checklist

Make sure your backend server is:

1. ✅ **Running** on the correct port (8080)
2. ✅ **Accepting POST requests** to `/nutritionv`
3. ✅ **Returning JSON** in the correct format
4. ✅ **Accessible** from your device/emulator

## 🧪 Test Your Backend

### From Terminal (macOS/Linux):
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"food": "2 boiled eggs"}' \
  http://localhost:8080/nutritionv
```

### Expected Response:
```json
{
  "food": "2 boiled eggs",
  "nutrition_info": {
    "calories": 155,
    "protein": 12.6,
    "carbs": 1.1,
    "fat": 10.6
  }
}
```

## 🔍 Troubleshooting Steps

### Error: "Connection refused"

**Cause:** Backend server is not running or wrong port

**Solutions:**
1. Start your backend server
2. Verify it's running on port 8080
3. Check the port in your backend logs

### Error: "OS Error: Connection refused, errno = 111"

**Cause:** Wrong IP address or firewall blocking

**Solutions:**
1. For Android Emulator: Use `10.0.2.2:8080`
2. For iOS Simulator: Use `localhost:8080`
3. For Physical Device: Use your computer's IP
4. Check firewall settings

### Error: "Request timeout"

**Cause:** Backend is slow or not responding

**Solutions:**
1. Check backend logs for errors
2. Increase timeout in `app_config.dart`
3. Restart backend server

## 📝 Backend Setup Example (Node.js/Express)

If you don't have a backend yet, here's a quick setup:

```javascript
const express = require('express');
const app = express();

app.use(express.json());

// CORS for development
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

app.post('/nutritionv', (req, res) => {
  const { food } = req.body;
  
  console.log('Received request for:', food);
  
  // Mock response
  res.json({
    food: food,
    nutrition_info: {
      calories: 155,
      protein: 12.6,
      carbs: 1.1,
      fat: 10.6,
      fiber: 0,
      sugar: 0.6,
      serving_size: food
    }
  });
});

const PORT = 8080;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Nutrition API running on port ${PORT}`);
  console.log(`📡 Endpoint: http://localhost:${PORT}/nutritionv`);
});
```

Save as `server.js` and run:
```bash
node server.js
```

## 🔄 After Changing Configuration

1. Save the file
2. Hot reload in Flutter (press 'r' in terminal)
3. Or hot restart (press 'R' in terminal)
4. Try searching again

## 📱 Platform-Specific Notes

### Android Emulator
- `localhost` = `10.0.2.2`
- Already configured ✅

### iOS Simulator
- Can use `localhost` directly
- Change config if running on iOS

### Physical Device
- MUST use computer's local IP
- Device and computer must be on same WiFi

## 🎯 Current Configuration

**API Base URL:** `http://10.0.2.2:8080`
**Endpoint:** `/nutritionv`
**Timeout:** 30 seconds

This should work for **Android Emulator** with backend on **localhost:8080**

---

**Need more help?** Check `BACKEND_SETUP.md` for detailed backend setup instructions.
