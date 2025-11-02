# CalPal Project Structure

## Complete File Structure

```
calpal/
├── lib/
│   ├── main.dart                              # App entry point with GetMaterialApp
│   └── app/
│       ├── core/
│       │   └── config/
│       │       └── app_config.dart            # Centralized app configuration
│       ├── data/
│       │   ├── models/
│       │   │   └── nutrition_model.dart       # Data models for nutrition info
│       │   └── services/
│       │       └── nutrition_service.dart     # HTTP service for API calls
│       ├── modules/
│       │   └── home/
│       │       ├── bindings/
│       │       │   └── home_binding.dart      # Dependency injection
│       │       ├── controllers/
│       │       │   └── home_controller.dart   # Business logic & state management
│       │       └── views/
│       │           └── home_view.dart         # UI components
│       └── routes/
│           ├── app_pages.dart                 # Route definitions
│           └── app_routes.dart                # Route constants
├── pubspec.yaml                               # Dependencies
├── README.md                                  # Project documentation
└── BACKEND_SETUP.md                          # Backend API setup guide
```

## Architecture Overview

### MVC Pattern with GetX

```
┌─────────────────────────────────────────────────────────┐
│                         VIEW                            │
│                    (home_view.dart)                     │
│  • Search input field                                   │
│  • Results display                                      │
│  • Search history chips                                 │
└─────────────────┬───────────────────────────────────────┘
                  │ User interactions
                  │ (Search, clear, history selection)
                  ▼
┌─────────────────────────────────────────────────────────┐
│                      CONTROLLER                         │
│                 (home_controller.dart)                  │
│  • State management (GetX observables)                  │
│  • Business logic                                       │
│  • Calls service layer                                  │
└─────────────────┬───────────────────────────────────────┘
                  │ Service calls
                  ▼
┌─────────────────────────────────────────────────────────┐
│                       SERVICE                           │
│                (nutrition_service.dart)                 │
│  • HTTP requests                                        │
│  • API integration                                      │
│  • Error handling                                       │
└─────────────────┬───────────────────────────────────────┘
                  │ HTTP POST
                  ▼
┌─────────────────────────────────────────────────────────┐
│                    BACKEND API                          │
│              POST /nutritionv                           │
│  • Processes food query                                 │
│  • Returns nutrition data                               │
└─────────────────────────────────────────────────────────┘
```

## Key Components

### 1. Models (`lib/app/data/models/`)

**nutrition_model.dart**
- `NutritionModel`: Main response model
- `NutritionInfo`: Detailed nutrition data
- JSON serialization/deserialization

### 2. Services (`lib/app/data/services/`)

**nutrition_service.dart**
- `getNutritionInfo(String food)`: Fetches nutrition data
- `checkServerHealth()`: Verifies backend connectivity
- HTTP error handling
- Timeout management

### 3. Controllers (`lib/app/modules/home/controllers/`)

**home_controller.dart**
- Extends `GetxController`
- Observable variables:
  - `isLoading`: Loading state
  - `nutritionData`: Current results
  - `searchHistory`: Recent searches
  - `errorMessage`: Error display
- Methods:
  - `searchNutrition()`: Performs search
  - `clearSearch()`: Resets search
  - `searchFromHistory()`: Re-search from history

### 4. Views (`lib/app/modules/home/views/`)

**home_view.dart**
- Extends `GetView<HomeController>`
- UI Sections:
  - `_buildSearchSection()`: Search input and button
  - `_buildResultSection()`: Nutrition results display
  - `_buildSearchHistorySection()`: Recent searches
- Reactive UI with `Obx` widgets

### 5. Bindings (`lib/app/modules/home/bindings/`)

**home_binding.dart**
- Implements `Bindings`
- Lazy initialization of `HomeController`
- Dependency injection for the home module

### 6. Routes (`lib/app/routes/`)

**app_routes.dart**
- Route constants
- `Routes.HOME`: Home page route

**app_pages.dart**
- `GetPage` definitions
- Bindings association
- Initial route configuration

### 7. Configuration (`lib/app/core/config/`)

**app_config.dart**
- `apiBaseUrl`: Backend URL
- `apiTimeout`: Request timeout
- `maxSearchHistoryItems`: History limit
- App metadata

## Data Flow

1. **User Input** → User enters food item and clicks search
2. **View** → Calls `controller.onSearchPressed()`
3. **Controller** → Validates input, sets `isLoading = true`
4. **Controller** → Calls `nutritionService.getNutritionInfo(food)`
5. **Service** → Makes HTTP POST to backend API
6. **Service** → Returns `NutritionModel` with data or error
7. **Controller** → Updates `nutritionData` or `errorMessage`
8. **View** → UI updates automatically via GetX observables
9. **User** → Sees results or error message

## State Management

### GetX Observables

```dart
// In Controller
final isLoading = false.obs;
final nutritionData = Rx<NutritionModel?>(null);

// In View
Obx(() => controller.isLoading.value 
  ? CircularProgressIndicator() 
  : SearchButton()
)
```

### Benefits of GetX

- ✅ Minimal boilerplate
- ✅ Reactive programming
- ✅ Performance optimization
- ✅ Easy dependency injection
- ✅ Route management

## API Integration

### Request Format
```dart
POST http://localhost:8080/nutritionv
Content-Type: application/json

{
  "food": "2 boiled eggs"
}
```

### Response Format
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

## Dependencies

```yaml
dependencies:
  get: ^4.6.6      # State management & routing
  http: ^1.2.0     # HTTP requests
```

## Running the App

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Ensure backend is running** on `http://localhost:8080`

3. **Run the app:**
   ```bash
   flutter run
   ```

4. **For Android emulator**, update config to use `http://10.0.2.2:8080`

5. **For physical device**, use your computer's IP address

## Testing

### Manual Testing Checklist

- [ ] Search with valid food item
- [ ] Search with empty input (should show error)
- [ ] Search with invalid food (backend should return error)
- [ ] Backend offline scenario
- [ ] Search history functionality
- [ ] Clear search functionality
- [ ] Search from history chips
- [ ] Clear history functionality
- [ ] Loading indicator displays
- [ ] Results display correctly
- [ ] All nutrition fields render properly

## Future Enhancements

- Local storage for search history (using GetStorage)
- User authentication
- Daily nutrition tracking
- Charts and graphs
- Food favorites
- Barcode scanning
- Meal planning
- Dark theme support

## Troubleshooting

### Common Issues

1. **"Failed to fetch nutrition data"**
   - Check if backend is running
   - Verify API URL in `app_config.dart`
   - Check network connectivity

2. **"Request timeout"**
   - Backend may be slow
   - Increase timeout in `app_config.dart`

3. **Empty results**
   - Check backend response format
   - Verify JSON structure matches models

4. **Android emulator can't reach localhost**
   - Use `10.0.2.2` instead of `localhost`
