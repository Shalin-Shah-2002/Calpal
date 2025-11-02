# Connection Troubleshooting Guide

## Current Issue
- **Error**: `TimeoutException after 0:00:30.000000: Future not completed`
- **Endpoint**: `/nutrition`
- **Backend**: Running on `localhost:3000` ✅ (tested and working)

## ✅ Backend is Working
```bash
curl -X POST http://localhost:3000/nutrition \
  -H "Content-Type: application/json" \
  -d '{"food": "apple"}'
```
Response received successfully in < 1 second!

## Possible Causes

### 1. **Wrong URL for Your Device** (MOST LIKELY)

#### Are you using Android Emulator?
- **Current setting**: `http://10.0.2.2:3000` ✅ (should work)
- **Fixed**: Code now auto-detects platform

#### Are you using iOS Simulator?
- **Required**: `http://localhost:3000` ✅ (now auto-configured)

#### Are you using Physical Device?
- **Required**: Your computer's local IP (e.g., `http://192.168.1.5:3000`)
- **How to find your IP**:
  ```bash
  # On macOS
  ipconfig getifaddr en0
  ```
- **Then update**: Uncomment line in `app_config.dart` and set your IP

### 2. **Backend Not Allowing Connections**

Check if your backend has CORS enabled:

```javascript
// In your Express backend
const cors = require('cors');
app.use(cors()); // Allow all origins for development
```

### 3. **Backend Process Issues**

Make sure backend is running:
```bash
# Check if process is listening on port 3000
lsof -i :3000
```

## 🔧 What I Fixed

1. **Added Debug Logging**: You'll now see in console:
   - 🔍 URL being called
   - 📦 Request body
   - ⏱️ Timeout messages
   - ✅ Response status

2. **Platform Auto-Detection**: Automatically uses correct URL for Android/iOS

3. **Better Error Messages**: Clearer timeout explanation

## 🧪 Next Steps

1. **Run the app** and check the console output
2. **Look for** the 🔍 log showing which URL it's trying to reach
3. **If using physical device**: Uncomment and set your IP in `app_config.dart`
4. **Test search** and watch the logs

## Expected Console Output

```
🔍 Attempting to fetch nutrition from: http://10.0.2.2:3000/nutrition
📦 Request body: {"food":"apple"}
✅ Response received: 200
```

If you see timeout instead:
```
⏱️ Request timed out after 30 seconds
```

This means the app **cannot reach** the backend. Check:
- Is backend running? (`lsof -i :3000`)
- Using correct IP for your device type?
- Firewall blocking connections?
