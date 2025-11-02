# 📚 CalPal - Complete Project Documentation

## 📖 Quick Navigation

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | Main project overview, features, installation |
| [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md) | Detailed architecture explanation (MVC + GetX) |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute to the project |
| [CHANGELOG.md](CHANGELOG.md) | Version history and changes |
| [LICENSE](LICENSE) | MIT License |

---

## 🎯 Project Overview

**CalPal** is a personal Flutter application that combines Google Gemini AI with PostgreSQL to create a modern nutrition tracking experience.

### Key Features
- 🔍 AI-powered food search
- 💾 Save and track nutrition data
- 📅 Calendar-based history view
- 📊 Daily nutrition summaries
- 🎨 Modern Material Design 3 UI

### Current Status
- ✅ **Version**: 1.0.0
- 📅 **Release Date**: November 2, 2025
- 🔐 **Authentication**: Not implemented (personal project)
- ☁️ **Cloud Sync**: Not implemented
- 📱 **Platforms**: Android, iOS, Web, Desktop (cross-platform)

---

## 🏗️ Architecture Summary

### Tech Stack
```
Frontend:  Flutter 3.9.2 + GetX 4.6.6
Backend:   Node.js + Express
Database:  PostgreSQL
AI:        Google Gemini AI
```

### Design Pattern
**MVC (Model-View-Controller) + GetX**

```
┌─────────────────────────────────────┐
│           View Layer                │
│  (UI Components - home_view.dart)   │
└───────────┬─────────────────────────┘
            │ User Actions
            ▼
┌─────────────────────────────────────┐
│        Controller Layer             │
│ (Business Logic - home_controller)  │
└───────────┬─────────────────────────┘
            │ Data Requests
            ▼
┌─────────────────────────────────────┐
│         Service Layer               │
│  (API Calls - nutrition_service)    │
└───────────┬─────────────────────────┘
            │ HTTP Requests
            ▼
┌─────────────────────────────────────┐
│      Backend + Database             │
│   (Node.js + PostgreSQL + Gemini)   │
└─────────────────────────────────────┘
```

---

## 📁 Project Structure

```
calpal/
├── lib/
│   ├── app/
│   │   ├── data/
│   │   │   ├── models/           # Data structures
│   │   │   │   ├── nutrition_model.dart
│   │   │   │   └── saved_nutrition_model.dart
│   │   │   └── services/         # API layer
│   │   │       └── nutrition_service.dart
│   │   │
│   │   ├── modules/              # Features
│   │   │   ├── home/             # Search & Save
│   │   │   │   ├── bindings/
│   │   │   │   ├── controllers/
│   │   │   │   └── views/
│   │   │   └── history/          # Calendar & History
│   │   │       ├── bindings/
│   │   │       ├── controllers/
│   │   │       └── views/
│   │   │
│   │   ├── routes/               # Navigation
│   │   │   ├── app_pages.dart
│   │   │   └── app_routes.dart
│   │   │
│   │   └── core/                 # Config & Utils
│   │       └── config/
│   │           └── app_config.dart
│   │
│   └── main.dart                 # Entry point
│
├── android/                       # Android platform
├── ios/                          # iOS platform
├── web/                          # Web platform
├── macos/                        # macOS platform
├── linux/                        # Linux platform
├── windows/                      # Windows platform
│
├── test/                         # Unit tests
│
├── README.md                     # Main documentation
├── ARCHITECTURE_GUIDE.md         # Architecture details
├── CONTRIBUTING.md               # Contribution guide
├── CHANGELOG.md                  # Version history
├── LICENSE                       # MIT License
│
├── pubspec.yaml                  # Dependencies
└── analysis_options.yaml         # Linting rules
```

---

## 🔌 API Documentation

### Endpoints

#### 1. Search Nutrition
```http
POST /nutrition
Content-Type: application/json

{
  "food": "apple"
}
```

**Response:**
```json
{
  "food_name": "apple",
  "serving_size": "100g",
  "calories": 52,
  "macronutrients": { ... },
  "micronutrients": { ... },
  "healthy_score": 8,
  "notes": "AI-generated health advice"
}
```

#### 2. Save Nutrition
```http
POST /save
Content-Type: application/json

{
  "food_name": "apple",
  "serving_size": "100g",
  "calories": 52,
  ...
}
```

#### 3. Get by Date
```http
GET /save/date/2025-11-02
```

**Response:**
```json
{
  "success": true,
  "date": "2025-11-02",
  "count": 3,
  "data": [...]
}
```

#### 4. Delete Item
```http
DELETE /save/:id
```

---

## 🚀 Quick Start Guide

### 1. Prerequisites
- Flutter SDK (>=3.9.2)
- Node.js
- PostgreSQL
- Gemini API key

### 2. Installation
```bash
# Clone repository
git clone https://github.com/yourusername/calpal.git
cd calpal

# Install dependencies
flutter pub get

# Setup backend
cd backend
npm install
echo "GEMINI_API_KEY=your_key" > .env
npm start

# Run app
flutter run
```

### 3. Configuration
Update `lib/app/core/config/app_config.dart`:
```dart
// For Android Emulator
static String get apiBaseUrl => 'http://10.0.2.2:3000';

// For iOS Simulator  
static String get apiBaseUrl => 'http://localhost:3000';

// For Physical Device
static String get apiBaseUrl => 'http://YOUR_IP:3000';
```

---

## 📱 User Flows

### Flow 1: Search and Save
```
1. User opens app → Home screen
2. User enters food name → "apple"
3. User clicks search → Loading spinner
4. Results appear → Nutrition card with health score
5. User clicks Save → Success message
6. Item saved to database
```

### Flow 2: View History
```
1. User taps History tab → Calendar screen
2. Screen loads today's data → Shows 3 items
3. Daily summary card → Total: 450 cal
4. User taps item → Detail bottom sheet
5. User views full nutrition info
```

### Flow 3: Delete Item
```
1. User in History screen
2. User taps delete icon → Confirmation dialog
3. User confirms → API call
4. Item removed → List updates
5. Daily totals recalculate
```

---

## 🎨 UI Components

### Home Screen
- Search TextField
- Search Button
- Loading Indicator
- Nutrition Results Card
  - Food name & serving size
  - Health score badge
  - Macros summary
  - Micros expandable section
  - AI notes
  - Save button
- Search History List

### History Screen
- Date Selector
  - Previous day button
  - Current date display
  - Next day button
  - Today button
- Daily Summary Card
  - Total calories
  - Total macros
  - Item count
- Nutrition Items List
  - Food name
  - Calories & protein
  - Health score
  - Delete button
- Empty State Message

### Bottom Navigation
- Search tab (Home icon)
- History tab (Calendar icon)

---

## 🔧 Development Commands

```bash
# Run app
flutter run

# Run tests
flutter test

# Check for issues
flutter analyze

# Build APK (Android)
flutter build apk --release

# Build for iOS
flutter build ios --release

# Build for Web
flutter build web --release

# Generate coverage report
flutter test --coverage

# Clean build files
flutter clean
```

---

## 🐛 Troubleshooting

### Timeout Errors
**Problem**: Request timeout after 30 seconds

**Solutions**:
1. Check backend is running on port 3000
2. Verify API URL matches device type
3. Test endpoint manually:
   ```bash
   curl http://localhost:3000/nutrition \
     -H "Content-Type: application/json" \
     -d '{"food": "apple"}'
   ```

### Build Errors
**Problem**: Gradle/Pod installation fails

**Solutions**:
1. `flutter clean`
2. `flutter pub get`
3. For Android: `cd android && ./gradlew clean`
4. For iOS: `cd ios && pod install`

### API Connection Issues
**Problem**: Can't connect to backend from device

**Solutions**:
1. Android Emulator → Use `http://10.0.2.2:3000`
2. iOS Simulator → Use `http://localhost:3000`
3. Physical Device → Use computer's IP (e.g., `http://192.168.1.5:3000`)

---

## 🎯 Future Roadmap

### Version 2.0 (Planned)
- [ ] User authentication
- [ ] Cloud synchronization
- [ ] Multi-device support
- [ ] Advanced analytics
- [ ] Meal planning
- [ ] Barcode scanner
- [ ] Recipe integration
- [ ] Social features

### Long-term Vision
- [ ] Web dashboard
- [ ] Nutritionist partnerships
- [ ] Premium features
- [ ] Mobile + Desktop + Web platforms
- [ ] Smartwatch integration
- [ ] Voice commands
- [ ] AI meal recommendations

---

## 📊 Project Stats

### Code Statistics
- **Language**: Dart (Flutter)
- **Lines of Code**: ~5,000+ lines
- **Files**: 50+ files
- **Screens**: 2 main screens (Home, History)
- **API Endpoints**: 4 endpoints
- **Models**: 2 data models

### Dependencies
- **Production**: 3 packages (get, http, intl)
- **Development**: 2 packages (flutter_test, flutter_lints)

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Ways to contribute**:
- 🐛 Report bugs
- 💡 Suggest features
- 📝 Improve documentation
- 💻 Submit code
- ⭐ Star the repo

---

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Shalin Shah**
- Personal project started: November 2025
- Built with Flutter and Google Gemini AI

---

## 🙏 Credits

- **Google Gemini AI** - Nutrition analysis
- **GetX Team** - State management framework
- **Flutter Team** - Cross-platform framework
- **Open Source Community** - Inspiration and tools

---

## 📞 Support & Contact

- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/calpal/issues)
- 💡 **Feature Requests**: [GitHub Discussions](https://github.com/yourusername/calpal/discussions)
- 📧 **Email**: your.email@example.com
- 🌟 **Stars**: Much appreciated!

---

## 📝 Notes

### Project Philosophy
CalPal is built on these principles:
- **Simplicity**: Easy to use, no complexity
- **Speed**: Fast searches, instant results
- **Privacy**: Local-first (no auth required initially)
- **Quality**: Clean code, good architecture
- **Open**: Open source, welcoming contributions

### Why No Authentication?
This is a personal project focused on core functionality first. Authentication and cloud sync will be added in v2.0 if the app gains user interest and traction.

### Technology Choices
- **Flutter**: Cross-platform with native performance
- **GetX**: Lightweight, powerful state management
- **Gemini AI**: Latest AI for accurate nutrition data
- **PostgreSQL**: Reliable, scalable database
- **MVC**: Clean, testable architecture

---

<div align="center">

**CalPal v1.0.0** - Built with ❤️ using Flutter

*Making healthy eating easier, one search at a time* 🥗

</div>
