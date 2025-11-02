# 🎯 Quick Start Guide - CalPal

## ✅ What's Been Created

Your CalPal app now has a complete MVC architecture with GetX!

### 📁 File Structure Created

```
lib/
├── main.dart                                    ✅ GetX app configuration
└── app/
    ├── core/config/app_config.dart             ✅ Centralized settings
    ├── data/
    │   ├── models/nutrition_model.dart          ✅ Data models
    │   └── services/nutrition_service.dart      ✅ API service
    ├── modules/home/
    │   ├── bindings/home_binding.dart           ✅ Dependency injection
    │   ├── controllers/home_controller.dart     ✅ Business logic
    │   └── views/home_view.dart                 ✅ UI components
    └── routes/
        ├── app_pages.dart                       ✅ Route configuration
        └── app_routes.dart                      ✅ Route constants
```

## 🚀 How to Run

### Step 1: Install Dependencies
```bash
cd "/Users/shalinshah/Developer-Shalin /Node-Js-Practice/calpal"
flutter pub get
```

### Step 2: Start Your Backend
Make sure your nutrition API is running at:
```
http://localhost:8080/nutritionv
```

### Step 3: Run the App
```bash
flutter run
```

## 🔧 Configuration

### Change API URL
Edit `lib/app/core/config/app_config.dart`:
```dart
static const String apiBaseUrl = 'http://localhost:8080';
```

### For Android Emulator
Use this URL instead:
```dart
static const String apiBaseUrl = 'http://10.0.2.2:8080';
```

### For Physical Device
Use your computer's IP:
```dart
static const String apiBaseUrl = 'http://192.168.x.x:8080';
```

## 📱 Features

✅ **Search Nutrition Info** - Enter food items like "2 boiled eggs"  
✅ **View Results** - See calories, protein, carbs, fat, fiber, sugar  
✅ **Search History** - Quick access to recent searches  
✅ **Error Handling** - User-friendly error messages  
✅ **Loading States** - Visual feedback during API calls  
✅ **Reactive UI** - Automatic updates with GetX  

## 🏗️ Architecture

**Model** → Data structures (`nutrition_model.dart`)  
**View** → UI components (`home_view.dart`)  
**Controller** → Business logic (`home_controller.dart`)  
**Service** → API integration (`nutrition_service.dart`)  

## 📝 API Format

### Your Backend Should Accept:
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"food": "2 boiled eggs"}' \
  http://localhost:8080/nutritionv
```

### And Return:
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

## 📚 Documentation

- `README.md` - Project overview
- `BACKEND_SETUP.md` - Backend API setup guide
- `PROJECT_STRUCTURE.md` - Detailed architecture documentation

## 🎨 UI Preview

The app includes:
- 🔍 Search card with input field and button
- 📊 Nutrition results card with colored icons
- 📝 Search history chips
- ⚠️ Error messages with red styling
- ⏳ Loading indicators

## 🧪 Test Your Setup

1. ✅ Dependencies installed: `flutter pub get`
2. ✅ Backend running on port 8080
3. ✅ Test API with curl command
4. ✅ Run app: `flutter run`
5. ✅ Search for "2 boiled eggs"
6. ✅ View nutrition results

## 💡 Next Steps

1. Start your backend server
2. Update API URL if needed
3. Run the Flutter app
4. Try searching for food items!

## ❓ Troubleshooting

**Problem:** "Failed to fetch nutrition data"  
**Solution:** Check backend is running and URL is correct

**Problem:** App can't connect on Android emulator  
**Solution:** Use `http://10.0.2.2:8080` instead of localhost

**Problem:** Request timeout  
**Solution:** Increase timeout in `app_config.dart`

## 📞 Need Help?

Check the documentation files:
- `BACKEND_SETUP.md` - For API setup issues
- `PROJECT_STRUCTURE.md` - For architecture questions
- `README.md` - For general usage

---

**Happy Coding! 🚀**
