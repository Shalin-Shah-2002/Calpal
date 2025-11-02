# Changelog

All notable changes to CalPal will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- User authentication (email, Google, Apple sign-in)
- Cloud sync across devices
- Meal planning features
- Advanced analytics with charts
- Barcode scanner
- Recipe integration
- Social features

---

## [1.0.0] - 2025-11-02

### 🎉 Initial Release

#### Added
- **Smart Food Search**
  - AI-powered nutrition search using Google Gemini
  - Instant nutrition lookup for any food item
  - Search history for quick re-searches
  
- **Detailed Nutrition Information**
  - Macronutrients display (calories, protein, carbs, fats, fiber, sugars)
  - Micronutrients display (sodium, potassium, calcium, iron, vitamins C, D, B12)
  - AI-generated health score (1-10 rating)
  - Personalized health notes from Gemini AI
  
- **Save & Track Features**
  - Save nutrition data to database
  - View saved items by date
  - Delete saved items
  - Daily nutrition totals calculator
  
- **History & Calendar**
  - Calendar-style date navigation
  - Daily summary cards showing totals
  - Previous/Next day navigation
  - Jump to today button
  - Empty state handling
  
- **Modern UI/UX**
  - Material Design 3 implementation
  - Color-coded health scores (red, orange, green)
  - Bottom navigation bar (Search + History tabs)
  - Smooth animations and transitions
  - Loading states
  - Error handling with user-friendly messages
  - Success/error snackbars
  
- **Architecture**
  - MVC architecture with GetX
  - Separation of concerns (Models, Views, Controllers, Services)
  - Dependency injection via Bindings
  - Reactive state management
  - Clean code organization
  
- **Documentation**
  - Comprehensive README.md
  - Architecture guide (ARCHITECTURE_GUIDE.md)
  - Contributing guidelines (CONTRIBUTING.md)
  - API endpoint documentation
  - Code comments and examples

#### Technical Details
- Flutter 3.9.2
- GetX 4.6.6 for state management
- HTTP 1.2.0 for API calls
- intl 0.19.0 for date formatting
- Node.js + Express backend
- PostgreSQL database
- Google Gemini AI integration

#### API Endpoints
- `POST /nutrition` - Get nutrition information
- `POST /save` - Save nutrition data
- `GET /save/date/:date` - Retrieve items by date
- `DELETE /save/:id` - Delete saved item

---

## Version History Legend

### Types of Changes
- `Added` - New features
- `Changed` - Changes in existing functionality
- `Deprecated` - Soon-to-be removed features
- `Removed` - Now removed features
- `Fixed` - Bug fixes
- `Security` - Security fixes

---

## Future Versions (Planned)

### [2.0.0] - TBD (If app gains traction)

#### Planned Features
- User authentication and profiles
- Cloud synchronization
- Multi-device support
- Backup and restore
- Weekly/monthly analytics
- Goal setting and tracking
- Meal planning
- Recipe integration
- Water intake tracking
- Weight tracking
- Social features
- Premium features

---

## Notes

**Current Status**: Personal Project (No Authentication)

This is currently a personal project without user authentication. All data is stored locally. Future versions will include authentication and cloud sync if the app gains traction and user interest.

**Feedback Welcome**: If you're using CalPal and have suggestions, please open an issue on GitHub!

---

[Unreleased]: https://github.com/yourusername/calpal/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/calpal/releases/tag/v1.0.0
