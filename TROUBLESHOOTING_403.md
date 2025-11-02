# 🔧 Troubleshooting 403 Error

## What Does 403 Mean?

A **403 Forbidden** error means the server understood your request but refuses to authorize it.

## Common Causes & Solutions

### 1️⃣ CORS Issue (Most Common)

**Problem:** Your backend doesn't allow requests from the Flutter app.

**Solution:** Add CORS headers to your backend.

#### For Express.js (Node.js):
```javascript
const express = require('express');
const app = express();

// Add this BEFORE your routes
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  res.header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

app.use(express.json());

// Your routes here...
```

#### For Other Backends:
Make sure your backend returns these headers:
```
Access-Control-Allow-Origin: *
Access-Control-Allow-Headers: Content-Type
Access-Control-Allow-Methods: GET, POST, OPTIONS
```

### 2️⃣ Wrong Endpoint

**Problem:** The `/nutritionv` endpoint doesn't exist.

**Solution:** Verify your backend has this exact endpoint.

**Test from terminal:**
```bash
# Test if endpoint exists
curl -X POST -H "Content-Type: application/json" \
  -d '{"food": "apple"}' \
  http://localhost:8080/nutritionv
```

### 3️⃣ Backend Not Running

**Problem:** Backend might have crashed or not started.

**Solution:** Check if your backend is running on port 8080.

**Test from terminal:**
```bash
# Check if port 8080 is listening
lsof -i :8080

# Or use curl to test
curl http://localhost:8080/health
```

### 4️⃣ Authentication Required

**Problem:** Your API requires authentication tokens.

**Solution:** Add authentication headers if needed (uncommon for local development).

---

## 🧪 Quick Tests

### Test 1: Check if Backend is Running
```bash
curl http://localhost:8080/health
```
**Expected:** `{"status":"ok",...}`

### Test 2: Test the Nutrition Endpoint
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"food": "apple"}' \
  http://localhost:8080/nutritionv
```
**Expected:** JSON with nutrition info

### Test 3: Check from Android Emulator's Perspective
```bash
# This tests the 10.0.2.2 address (only works if you're on the host)
curl -X POST -H "Content-Type: application/json" \
  -d '{"food": "apple"}' \
  http://10.0.2.2:8080/nutritionv
```

---

## 🚀 Quick Fix: Use the Provided Backend

I've created a ready-to-use backend in the `backend/` folder:

### Step 1: Install Dependencies
```bash
cd backend
npm install
```

### Step 2: Start the Server
```bash
npm start
```

You should see:
```
==================================================
🚀 CalPal Nutrition API Server
==================================================
✅ Server running on port 8080
📡 Local:   http://localhost:8080
📡 Network: http://0.0.0.0:8080
==================================================
```

### Step 3: Test It
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"food": "2 boiled eggs"}' \
  http://localhost:8080/nutritionv
```

### Step 4: Hot Reload Your Flutter App
Press `r` in the Flutter terminal to hot reload.

---

## 🔍 Debugging Steps

1. **Check Backend Logs**
   - Look at your backend terminal for error messages
   - See if the request is even reaching your backend

2. **Verify Port**
   - Make sure backend is on port 8080
   - Check `lsof -i :8080`

3. **Check Flutter App Logs**
   - Look for the actual URL being called
   - Check for any network errors

4. **Test with Postman/Insomnia**
   - Try calling your API with a REST client
   - If it works there but not in Flutter, it's likely CORS

---

## 📝 Backend Checklist

- [ ] Backend is running on port 8080
- [ ] CORS headers are enabled
- [ ] `/nutritionv` endpoint exists
- [ ] Endpoint accepts POST requests
- [ ] Content-Type: application/json is accepted
- [ ] No authentication required (for local dev)
- [ ] Server listens on `0.0.0.0` (not just `127.0.0.1`)

---

## 🔄 After Fixing Backend

1. Make sure backend is running
2. In Flutter terminal, press `R` (capital R) for hot restart
3. Try searching again

---

## 💡 Still Not Working?

### Option A: Use the Mock Backend
The backend I created (`backend/server.js`) has:
- ✅ CORS enabled
- ✅ Proper error handling
- ✅ Mock nutrition database
- ✅ Request logging

Just run:
```bash
cd backend
npm install
npm start
```

### Option B: Check Your Backend URL
Your current config: `http://10.0.2.2:8080`

Try changing to localhost and test on iOS Simulator:
```dart
static const String apiBaseUrl = 'http://localhost:8080';
```

### Option C: Use a Real Device
If using a physical device:
1. Find your computer's IP: `ifconfig | grep "inet "`
2. Update config: `http://192.168.x.x:8080`
3. Ensure backend listens on `0.0.0.0`

---

## 📱 Current Configuration

**API URL:** `http://10.0.2.2:8080`
**Endpoint:** `/nutritionv`
**Method:** POST
**Headers:** `Content-Type: application/json`
**Body:** `{"food": "..."}`

This should work IF:
- ✅ You're on Android Emulator
- ✅ Backend is on localhost:8080
- ✅ CORS is enabled
- ✅ Endpoint exists
