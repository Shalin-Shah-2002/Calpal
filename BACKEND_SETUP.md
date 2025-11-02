# Backend Setup Guide

This Flutter app requires a backend API to provide nutrition information. Here's how to set it up:

## API Endpoint Specification

Your backend should expose the following endpoint:

### POST `/nutritionv`

**Endpoint:** `http://localhost:8080/nutritionv`

**Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "food": "2 boiled eggs"
}
```

**Success Response (200 OK):**
```json
{
  "food": "2 boiled eggs",
  "nutrition_info": {
    "calories": 155,
    "protein": 12.6,
    "carbs": 1.1,
    "fat": 10.6,
    "fiber": 0,
    "sugar": 0.6,
    "serving_size": "2 large eggs"
  }
}
```

**Error Response (400 Bad Request):**
```json
{
  "food": "invalid food",
  "error": "Could not find nutrition information for this food"
}
```

## Example Backend Implementation (Node.js/Express)

```javascript
const express = require('express');
const app = express();

app.use(express.json());

// CORS middleware (for development)
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

app.post('/nutritionv', (req, res) => {
  const { food } = req.body;
  
  if (!food) {
    return res.status(400).json({ error: 'Food parameter is required' });
  }
  
  // Your nutrition lookup logic here
  // This is a mock response
  const nutritionInfo = {
    food: food,
    nutrition_info: {
      calories: 155,
      protein: 12.6,
      carbs: 1.1,
      fat: 10.6,
      fiber: 0,
      sugar: 0.6,
      serving_size: "2 large eggs"
    }
  };
  
  res.json(nutritionInfo);
});

app.listen(8080, () => {
  console.log('Nutrition API running on http://localhost:8080');
});
```

## Testing Your API

You can test your API endpoint using curl:

```bash
curl -X POST -H "Content-Type: application/json" -d '{"food": "2 boiled eggs"}' http://localhost:8080/nutritionv
```

Expected output:
```json
{
  "food": "2 boiled eggs",
  "nutrition_info": {
    "calories": 155,
    "protein": 12.6,
    "carbs": 1.1,
    "fat": 10.6,
    "fiber": 0,
    "sugar": 0.6,
    "serving_size": "2 large eggs"
  }
}
```

## Configuration

To change the API URL in the Flutter app:

1. Open `lib/app/core/config/app_config.dart`
2. Update the `apiBaseUrl` constant:
   ```dart
   static const String apiBaseUrl = 'http://your-api-url:port';
   ```

## Running on Android Emulator

If you're running the app on an Android emulator and your backend is on `localhost`:

1. Use `http://10.0.2.2:8080` instead of `http://localhost:8080`
2. Update in `app_config.dart`:
   ```dart
   static const String apiBaseUrl = 'http://10.0.2.2:8080';
   ```

## Running on iOS Simulator

If you're running on iOS simulator with localhost:

1. Use `http://localhost:8080` (works directly)
2. Or use your computer's IP address: `http://192.168.x.x:8080`

## Running on Physical Device

If testing on a physical device:

1. Find your computer's local IP address
   - macOS: System Preferences → Network
   - Windows: `ipconfig` in Command Prompt
   - Linux: `ifconfig` or `ip addr`

2. Update in `app_config.dart`:
   ```dart
   static const String apiBaseUrl = 'http://192.168.x.x:8080';
   ```

3. Make sure your device is on the same WiFi network as your computer

## Nutrition Data Fields

The API should return the following fields (all numeric values except serving_size):

- `calories` (number) - Energy in kcal
- `protein` (number) - Protein in grams
- `carbs` (number) - Carbohydrates in grams
- `fat` (number) - Fat in grams
- `fiber` (number, optional) - Fiber in grams
- `sugar` (number, optional) - Sugar in grams
- `serving_size` (string, optional) - Description of serving size
