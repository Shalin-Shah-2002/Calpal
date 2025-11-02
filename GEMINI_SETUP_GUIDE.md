# 🚀 CalPal with Gemini AI Backend - Setup Guide

Your Flutter app has been updated to work with your Gemini-powered nutrition API!

## ✅ What's Been Updated

### 1. **New Data Model** (`nutrition_model.dart`)
The app now supports the full response structure from your Gemini backend:
- `food_name` - Name of the food
- `serving_size` - Serving size in grams
- `calories` - Total calories
- `macronutrients` - Protein, carbs, fats, fiber, sugars
- `micronutrients` - Sodium, potassium, calcium, iron, vitamins
- `healthy_score` - AI-generated health rating (1-10)
- `notes` - Health advice from AI

### 2. **Updated API Configuration**
- **Endpoint**: `/nutrition` (changed from `/nutritionv`)
- **Port**: `3000` (changed from `8080`)
- **URL**: `http://10.0.2.2:3000` (for Android Emulator)

### 3. **Enhanced UI**
New features in the view:
- ✅ Health score badge with color coding
- ✅ Expandable micronutrients section
- ✅ AI-generated health notes
- ✅ Better visual hierarchy
- ✅ More detailed nutrition information

---

## 🎯 How to Run

### Step 1: Set Up Your Backend

1. **Create `.env` file** in your backend folder:
```bash
cd backend
touch .env
```

2. **Add your Gemini API Key** to `.env`:
```
GEMINI_API_KEY=your_actual_gemini_api_key_here
PORT=3000
```

3. **Install dependencies**:
```bash
npm install
```

4. **Start the server**:
```bash
node server.js
```

You should see:
```
✅ Node.js server running on http://localhost:3000
CORS is enabled for all origins.
```

### Step 2: Run Your Flutter App

```bash
cd "/Users/shalinshah/Developer-Shalin /Node-Js-Practice/calpal"
flutter run
```

---

## 📱 Platform-Specific Configuration

### For Android Emulator (Current Setup ✅)
Already configured! URL: `http://10.0.2.2:3000`

### For iOS Simulator
Edit `lib/app/core/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'http://localhost:3000';
```

### For Physical Device
1. Find your computer's IP address:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

2. Update `lib/app/core/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'http://192.168.x.x:3000';
```

---

## 🧪 Testing

### Test 1: Check Backend
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"food": "2 boiled eggs"}' \
  http://localhost:3000/nutrition
```

### Test 2: Try Different Foods
- "apple"
- "2 boiled eggs"
- "chicken breast 200g"
- "banana 150g"
- "rice bowl"

---

## 📊 Response Example

Your backend returns:
```json
{
  "food_name": "2 boiled eggs",
  "serving_size": "100",
  "calories": "155",
  "macronutrients": {
    "protein_g": "12.6",
    "carbohydrates_g": "1.1",
    "fats_g": "10.6",
    "fiber_g": "0",
    "sugars_g": "1.1"
  },
  "micronutrients": {
    "sodium_mg": "124",
    "potassium_mg": "126",
    "calcium_mg": "50",
    "iron_mg": "1.2",
    "vitamin_c_mg": "0",
    "vitamin_d_mcg": "2",
    "vitamin_b12_mcg": "1.1"
  },
  "healthy_score": "8",
  "notes": "Eggs are an excellent source of protein and vitamins. Great for muscle building!"
}
```

The Flutter app displays all this beautifully!

---

## ✨ New UI Features

### Health Score Badge
- **8-10**: Green gradient (Excellent)
- **6-7**: Light green (Good)
- **4-5**: Orange (Moderate)
- **1-3**: Red (Poor)

### Collapsible Sections
- Micronutrients are in an expandable tile
- Clean, organized layout
- Easy to scan

### AI Notes
- Green highlighted box
- Health advice from Gemini
- Context-specific tips

---

## 🔧 Troubleshooting

### "Connection refused"
✅ Make sure backend is running on port 3000
```bash
lsof -i :3000
```

### "Missing GEMINI_API_KEY"
✅ Check your `.env` file has the key

### "CORS error"
✅ Already handled in backend with:
```javascript
app.use(cors());
```

### "Server error: 500"
✅ Check backend console for Gemini API errors
✅ Verify your API key is valid

---

## 📝 File Structure

```
lib/
├── app/
│   ├── core/config/
│   │   └── app_config.dart           # ✅ Updated to port 3000
│   ├── data/
│   │   ├── models/
│   │   │   └── nutrition_model.dart   # ✅ New Gemini response model
│   │   └── services/
│   │       └── nutrition_service.dart # ✅ Updated endpoint /nutrition
│   └── modules/home/
│       ├── controllers/
│       │   └── home_controller.dart   # No changes needed
│       └── views/
│           └── home_view.dart         # ✅ Enhanced UI with new features
```

---

## 🎨 UI Enhancements

### Before
- Basic nutrition display
- Limited information
- Simple layout

### After
- ✨ Health score with color-coded gradient
- 📊 Complete macro & micronutrients
- 💡 AI-generated health tips
- 📱 Expandable sections
- 🎯 Better visual hierarchy
- 🌈 More colorful and engaging

---

## 🚀 Next Steps

1. **Start your backend**: `node server.js`
2. **Run Flutter app**: `flutter run`
3. **Search for food**: Try "2 boiled eggs"
4. **Explore features**:
   - Check the health score
   - Expand micronutrients
   - Read AI health notes
   - Use search history

---

## 💡 Tips

- The AI provides realistic nutrition data
- Health scores consider overall nutrition quality
- Serving sizes default to 100g if not specified
- Try different quantities: "2 eggs", "150g banana", etc.

---

**Enjoy your AI-powered nutrition tracker! 🎉**

Need help? Check the console logs in both Flutter and Node.js for debugging.
