# 🥗 CalPal - AI-Powered Nutrition Tracker# CalPal - Nutrition Tracker



<div align="center">A Flutter application for tracking nutrition information using GetX state management and MVC architecture.



![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?style=for-the-badge&logo=flutter)## Features

![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)

![GetX](https://img.shields.io/badge/GetX-4.6.6-8B5CF6?style=for-the-badge)- 🔍 Search nutrition information for food items

![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)- 📊 Display detailed nutritional data (calories, protein, carbs, fat, fiber, sugar)

- 📝 Search history tracking

**A modern, AI-powered nutrition tracking app that helps you make healthier food choices**- 🎨 Modern Material Design UI

- ⚡ GetX state management for reactive UI

[Features](#-features) • [Installation](#-installation) • [Architecture](#-architecture) • [Future Plans](#-future-plans)- 🏗️ Clean MVC architecture



</div>## Architecture



---This app follows the **MVC (Model-View-Controller)** pattern with **GetX** for state management:



## 📖 About```

lib/

**CalPal** is a personal project that combines the power of Google's Gemini AI with a clean, intuitive Flutter interface to help users track their daily nutrition intake. Simply search for any food item, and get instant, detailed nutritional information along with AI-powered health insights!├── app/

│   ├── data/

### 🎯 Why CalPal?│   │   ├── models/              # Data models

│   │   │   └── nutrition_model.dart

- **No Account Required**: Start tracking immediately - no sign-up needed (personal project, authentication planned for v2.0)│   │   └── services/            # API services

- **AI-Powered**: Uses Google Gemini AI for intelligent nutrition analysis│   │       └── nutrition_service.dart

- **Fast & Simple**: Search, save, and track in seconds│   ├── modules/

- **Health Score**: Each food gets a health rating (1-10) with personalized notes│   │   └── home/

- **Daily Tracking**: View your nutrition history with daily summaries│   │       ├── bindings/        # Dependency injection

- **Modern UI**: Material Design 3 with smooth animations│   │       │   └── home_binding.dart

│   │       ├── controllers/     # Business logic

---│   │       │   └── home_controller.dart

│   │       └── views/           # UI components

## ✨ Features│   │           └── home_view.dart

│   └── routes/                  # Navigation

### 🔍 **Smart Food Search**│       ├── app_pages.dart

- Search any food item (e.g., "2 boiled eggs", "apple", "pizza slice")│       └── app_routes.dart

- Powered by Google Gemini AI for accurate nutrition data└── main.dart                    # App entry point

- Get comprehensive nutritional breakdown instantly```

- Search history for quick re-searches

## Backend API

### 📊 **Detailed Nutrition Info**

- **Macronutrients**: Calories, Protein, Carbs, Fats, Fiber, SugarsThe app expects a backend service running at `http://localhost:8080` with the following endpoint:

- **Micronutrients**: Sodium, Potassium, Calcium, Iron, Vitamins (C, D, B12)

- **Health Score**: AI-rated score from 1-10### POST `/nutritionv`

- **Smart Notes**: Personalized health advice from Gemini AI

**Request:**

### 💾 **Save & Track**```json

- Save your favorite foods with one tap{

- Organize by date for easy tracking  "food": "2 boiled eggs"

- View daily nutrition totals}

- Delete items you no longer want```



### 📅 **History & Calendar****Response:**

- Calendar-style date navigation```json

- View saved items by date{

- Daily summary cards showing:  "food": "2 boiled eggs",

  - Total calories  "nutrition_info": {

  - Total protein, carbs, and fats    "calories": 155,

  - Number of items consumed    "protein": 12.6,

- Quick access to previous/next day or jump to today    "carbs": 1.1,

    "fat": 10.6,

### 🎨 **Modern UI/UX**    "fiber": 0,

- Material Design 3    "sugar": 0.6,

- Color-coded health scores (Red 1-3, Orange 4-6, Green 7-10)    "serving_size": "2 large eggs"

- Smooth animations and transitions  }

- Bottom navigation for easy switching}

- Responsive design```



---## Setup



## 🚀 Installation1. **Install Dependencies:**

   ```bash

### Prerequisites   flutter pub get

   ```

- Flutter SDK (>=3.9.2)

- Dart SDK (>=3.0.0)2. **Start Your Backend Server:**

- Node.js (for backend)   Make sure your nutrition API is running on `http://localhost:8080`

- PostgreSQL (for data storage)

3. **Run the App:**

### 1. Clone the Repository   ```bash

   flutter run

```bash   ```

git clone https://github.com/yourusername/calpal.git

cd calpal## Dependencies

```

- `get: ^4.6.6` - State management and routing

### 2. Install Flutter Dependencies- `http: ^1.2.0` - HTTP requests



```bash## Usage

flutter pub get

```1. Enter a food item in the search box (e.g., "2 boiled eggs")

2. Click the **Search** button or press Enter

### 3. Setup Backend3. View the nutrition information displayed on the card

4. Click on recent searches to quickly search again

The app requires a backend service with two main endpoints:

#### **Backend Setup** (Node.js + Express)
```bash
# Install backend dependencies
cd backend
npm install

# Add your Gemini API key to .env
echo "GEMINI_API_KEY=your_key_here" > .env

# Start the server
npm start  # Runs on port 3000
```

### 4. Configure API URL

Update the base URL in `lib/app/core/config/app_config.dart`:

```dart
// For Android Emulator
static String get apiBaseUrl => 'http://10.0.2.2:3000';

// For iOS Simulator
static String get apiBaseUrl => 'http://localhost:3000';

// For Physical Device (use your computer's IP)
// Uncomment and set your IP:
// return 'http://192.168.1.x:3000';
```

**To find your local IP:**
```bash
# On macOS/Linux
ipconfig getifaddr en0

# On Windows
ipconfig
```

### 5. Run the App

```bash
flutter run
```

---

## 🏗️ Architecture

CalPal follows the **MVC (Model-View-Controller)** pattern with **GetX** for state management.

### Project Structure

```
lib/
├── app/
│   ├── data/                          # Data layer
│   │   ├── models/
│   │   │   ├── nutrition_model.dart         # Gemini API response model
│   │   │   └── saved_nutrition_model.dart   # Database model
│   │   └── services/
│   │       └── nutrition_service.dart       # API service layer
│   │
│   ├── modules/                       # Feature modules
│   │   ├── home/                             # Search & Save feature
│   │   │   ├── bindings/
│   │   │   │   └── home_binding.dart        # Dependency injection
│   │   │   ├── controllers/
│   │   │   │   └── home_controller.dart     # Business logic
│   │   │   └── views/
│   │   │       └── home_view.dart           # UI
│   │   │
│   │   └── history/                          # History & Calendar feature
│   │       ├── bindings/
│   │       │   └── history_binding.dart
│   │       ├── controllers/
│   │       │   └── history_controller.dart
│   │       └── views/
│   │           └── history_view.dart
│   │
│   ├── routes/                        # Navigation
│   │   ├── app_pages.dart                   # Route definitions
│   │   └── app_routes.dart                  # Route names
│   │
│   └── core/                          # Core utilities
│       └── config/
│           └── app_config.dart              # Configuration
│
└── main.dart                          # Entry point
```

### Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | Flutter 3.9.2 | Cross-platform UI |
| **State Management** | GetX 4.6.6 | Reactive state & routing |
| **Backend** | Node.js + Express | REST API |
| **AI** | Google Gemini AI | Nutrition analysis |
| **Database** | PostgreSQL | Data persistence |
| **HTTP Client** | http 1.2.0 | API communication |
| **Date Formatting** | intl 0.19.0 | Date display |

For detailed architecture explanation, see [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md)

---

## 🔌 API Endpoints

### Backend Service (Port 3000)

| Endpoint | Method | Description | Request Body | Response |
|----------|--------|-------------|--------------|----------|
| `/nutrition` | POST | Get nutrition info | `{ "food": "apple" }` | Nutrition data with health score |
| `/save` | POST | Save nutrition data | Full nutrition object | Saved item with ID |
| `/save/date/:date` | GET | Get items by date | - | Array of saved items |
| `/save/:id` | DELETE | Delete saved item | - | Success status |

**Example Request:**
```bash
curl -X POST http://localhost:3000/nutrition \
  -H "Content-Type: application/json" \
  -d '{"food": "apple"}'
```

**Example Response:**
```json
{
  "food_name": "apple",
  "serving_size": "100g",
  "calories": 52,
  "macronutrients": {
    "protein_g": 0.3,
    "carbohydrates_g": 13.8,
    "fats_g": 0.2,
    "fiber_g": 2.4,
    "sugars_g": 10.4
  },
  "micronutrients": {
    "sodium_mg": 1,
    "potassium_mg": 107,
    "calcium_mg": 6,
    "iron_mg": 0.1,
    "vitamin_c_mg": 4.6,
    "vitamin_d_mcg": 0,
    "vitamin_b12_mcg": 0
  },
  "healthy_score": 8,
  "notes": "A good source of fiber and vitamin C..."
}
```

---

## 💡 How It Works

### 1. **Search Flow**
```
User enters "apple"
    ↓
HomeController.searchNutrition()
    ↓
NutritionService.getNutritionInfo()
    ↓
POST /nutrition → Gemini AI
    ↓
Returns detailed nutrition data
    ↓
HomeView displays results with Save button
```

### 2. **Save Flow**
```
User clicks "Save" button
    ↓
HomeController.saveNutritionData()
    ↓
NutritionService.saveNutrition()
    ↓
POST /save → PostgreSQL
    ↓
Returns saved item with ID
    ↓
Shows success snackbar
```

### 3. **History Flow**
```
User selects date in History tab
    ↓
HistoryController.loadNutritionForDate()
    ↓
NutritionService.getSavedNutritionByDate()
    ↓
GET /save/date/2025-11-02
    ↓
Returns array of saved items
    ↓
HistoryView displays with daily totals
```

---

## 🎯 Future Plans

### 🔜 Coming Soon (v2.0)

**If people like this app**, I plan to add:

#### **User Authentication** 🔐
- Sign up / Login with email
- Google / Apple sign-in
- User profiles and preferences
  
#### **Cloud Sync** ☁️
- Sync data across devices
- Backup & restore
- Offline-first with cloud sync

#### **Meal Planning** 🍽️
- Create meal plans
- Weekly meal prep
- Grocery lists

#### **Advanced Analytics** 📈
- Weekly/monthly reports
- Nutrient trends over time
- Goal tracking (calorie/protein targets)
- Charts and graphs
- Progress tracking

#### **Social Features** 👥
- Share favorite foods
- Community recipes
- Follow friends
- Nutrition challenges

#### **More Features**
- [ ] Barcode scanner for packaged foods
- [ ] Recipe integration with per-serving nutrition
- [ ] Water intake tracking
- [ ] Weight & body metrics tracking
- [ ] Custom food database
- [ ] Meal reminders
- [ ] Dark mode
- [ ] Multiple language support

### 🌟 If This App Gains Traction

If CalPal becomes popular, I'll:

1. **Add Premium Features**
   - Advanced analytics
   - Unlimited history
   - Export data to CSV/PDF
   - Custom themes
   - Ad-free experience

2. **Build a Community**
   - User forums
   - Recipe sharing platform
   - Nutrition tips blog
   - Expert Q&A sessions

3. **Partner with Professionals**
   - Nutritionist-approved meal plans
   - Personalized dietary advice
   - Health consultations

4. **Expand Platform Support**
   - Web app
   - Desktop app (Windows/Mac/Linux)
   - Smartwatch integration
   - Voice assistant integration

---

## 🛠️ Development

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Debugging

The app includes extensive logging:
- 🔍 API call URLs
- 📦 Request/response bodies
- ✅ Success messages
- ❌ Error details with stack traces

Check your console/terminal for debug output when testing.

---

## 🐛 Known Issues & Troubleshooting

### Timeout Errors
If you get timeout errors:
1. Make sure backend is running on port 3000
2. Check API URL matches your device type (Android/iOS/Physical)
3. Verify firewall isn't blocking connections

### Connection Issues
```bash
# Test backend manually
curl http://localhost:3000/nutrition \
  -H "Content-Type: application/json" \
  -d '{"food": "apple"}'

# Check if port is in use
lsof -i :3000
```

### For Physical Devices
You must use your computer's local IP address, not `localhost` or `10.0.2.2`.

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6           # State management & routing
  http: ^1.2.0          # HTTP requests
  intl: ^0.19.0         # Date formatting

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## 🤝 Contributing

This is currently a **personal project**, but contributions are welcome!

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Guidelines

- Follow the existing code style (MVC + GetX pattern)
- Add tests for new features
- Update documentation as needed
- Use meaningful commit messages
- Comment complex logic

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Shalin Shah**

- GitHub: [@shalinshah](https://github.com/shalinshah)
- Email: your.email@example.com

---

## 🙏 Acknowledgments

- **Google Gemini AI** - For powerful nutrition analysis capabilities
- **GetX Team** - For the amazing state management solution
- **Flutter Team** - For the incredible cross-platform framework
- **Open Source Community** - For endless inspiration and support

---

## ⭐ Show Your Support

If you like this project, please consider:
- ⭐ **Starring** the repository
- 🐛 **Reporting bugs** via Issues
- 💡 **Suggesting features** via Issues
- 🔀 **Contributing** via Pull Requests
- 📢 **Sharing** with others who might find it useful

Your feedback helps make CalPal better! 🚀

---

<div align="center">

### Made with ❤️ and Flutter

**CalPal** - Making healthy eating easier, one search at a time! 🥗

*This is a personal project with no authentication currently. Future versions will include user accounts and cloud sync if the app gains traction.*

---

**[⬆ Back to Top](#-calpal---ai-powered-nutrition-tracker)**

</div>
