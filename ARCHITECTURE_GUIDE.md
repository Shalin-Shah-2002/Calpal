# 🏗️ CalPal App Architecture Guide

## Overview: MVC + GetX Pattern

Your app follows the **MVC (Model-View-Controller)** pattern enhanced with **GetX** for state management and dependency injection.

---

## 📦 **Module Components**

### **1. Controller** - The Brain 🧠
**File**: `history_controller.dart`

**Purpose**: Manages business logic and state

```dart
class HistoryController extends GetxController {
  // 📊 STATE: Observable variables (reactive)
  final selectedDate = DateTime.now().obs;              // Current date
  final savedNutritionList = <SavedNutrition>[].obs;   // List of items
  final isLoading = false.obs;                          // Loading state
  final totalCalories = 0.0.obs;                        // Calculated total
  
  // 🔧 BUSINESS LOGIC: Methods
  Future<void> loadNutritionForDate(DateTime date) async {
    isLoading.value = true;
    // Call API service
    final data = await _nutritionService.getSavedNutritionByDate(date);
    savedNutritionList.value = data;
    _calculateTotals();
    isLoading.value = false;
  }
  
  Future<void> deleteNutrition(int id) async { ... }
  void previousDay() { ... }
  void nextDay() { ... }
}
```

**Key Features**:
- ✅ Observable state with `.obs` - UI auto-updates when these change
- ✅ Async operations (API calls)
- ✅ Calculations and data transformations
- ✅ Error handling
- ✅ No UI code!

---

### **2. Binding** - The Connector 🔌
**File**: `history_binding.dart`

**Purpose**: Dependency injection - creates and provides the controller

```dart
class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // Create controller when screen opens
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
```

**Key Features**:
- ✅ `lazyPut`: Creates controller only when needed
- ✅ Automatic cleanup when screen closes
- ✅ Singleton pattern - one instance per screen
- ✅ Can inject multiple dependencies

**Alternative Methods**:
```dart
// Create immediately when screen opens
Get.put<HistoryController>(HistoryController());

// Create new instance each time
Get.create<HistoryController>(() => HistoryController());

// Use existing instance (must be created already)
Get.find<HistoryController>();
```

---

### **3. View** - The Face 🎨
**File**: `history_view.dart`

**Purpose**: Displays UI and handles user interactions

```dart
class HistoryView extends GetView<HistoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 📅 Date Selector
          Row(
            children: [
              IconButton(
                onPressed: controller.previousDay,  // ← Call controller
                icon: Icon(Icons.arrow_back),
              ),
              Obx(() => Text(                       // ← Observe state
                DateFormat('MMMM d, y').format(controller.selectedDate.value),
              )),
              IconButton(
                onPressed: controller.nextDay,
                icon: Icon(Icons.arrow_forward),
              ),
            ],
          ),
          
          // 📊 Daily Summary
          Obx(() => Card(
            child: Text('Total Calories: ${controller.totalCalories.value}'),
          )),
          
          // 📋 List of Items
          Obx(() => controller.isLoading.value
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: controller.savedNutritionList.length,
                itemBuilder: (context, index) {
                  final item = controller.savedNutritionList[index];
                  return ListTile(
                    title: Text(item.foodName),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteNutrition(item.id!),
                    ),
                  );
                },
              ),
          ),
        ],
      ),
    );
  }
}
```

**Key Features**:
- ✅ `GetView<HistoryController>`: Automatically provides controller
- ✅ `Obx(() => ...)`: Reactive widget - rebuilds when state changes
- ✅ Calls controller methods on user actions
- ✅ No business logic here!

---

## 🔄 **Complete Flow Diagram**

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERACTION                          │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  │ User taps "History" tab
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                   GetX ROUTING                               │
│  GetPage(                                                    │
│    name: AppRoutes.HISTORY,                                  │
│    page: () => HistoryView(),                                │
│    binding: HistoryBinding(), ← Creates controller           │
│  )                                                           │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                   BINDING (history_binding.dart)             │
│                                                              │
│  Get.lazyPut(() => HistoryController());                     │
│                                                              │
│  • Creates controller instance                               │
│  • Injects into view                                         │
│  • Manages lifecycle                                         │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                CONTROLLER (history_controller.dart)          │
│                                                              │
│  onInit() {                                                  │
│    loadNutritionForDate(today);  ← Automatically called      │
│  }                                                           │
│                                                              │
│  loadNutritionForDate() {                                    │
│    isLoading.value = true;                                   │
│    data = await service.getSavedNutritionByDate(date);       │
│    savedNutritionList.value = data;  ← Update state          │
│    isLoading.value = false;                                  │
│  }                                                           │
└─────────────────┬───────────────────────────────────────────┘
                  │
                  │ State changes trigger UI update
                  ▼
┌─────────────────────────────────────────────────────────────┐
│                   VIEW (history_view.dart)                   │
│                                                              │
│  Obx(() => ListView.builder(                                 │
│    itemCount: controller.savedNutritionList.length, ← Observes│
│    itemBuilder: (context, index) {                           │
│      return ListTile(                                        │
│        title: Text(controller.savedNutritionList[index]),    │
│        onTap: () => controller.deleteNutrition(id), ← Action │
│      );                                                      │
│    },                                                        │
│  ))                                                          │
│                                                              │
│  • UI automatically rebuilds when state changes              │
│  • Displays data from controller                             │
│  • Calls controller methods on user actions                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 **Your App Structure**

```
lib/
├── app/
│   ├── data/                          # Data layer
│   │   ├── models/
│   │   │   ├── nutrition_model.dart         # Data structures
│   │   │   └── saved_nutrition_model.dart
│   │   └── services/
│   │       └── nutrition_service.dart       # API calls
│   │
│   ├── modules/                       # Feature modules
│   │   ├── home/
│   │   │   ├── bindings/
│   │   │   │   └── home_binding.dart        # DI: Creates HomeController
│   │   │   ├── controllers/
│   │   │   │   └── home_controller.dart     # Logic: Search, save
│   │   │   └── views/
│   │   │       └── home_view.dart           # UI: Search screen
│   │   │
│   │   └── history/
│   │       ├── bindings/
│   │       │   └── history_binding.dart     # DI: Creates HistoryController
│   │       ├── controllers/
│   │       │   └── history_controller.dart  # Logic: Load, delete, navigate
│   │       └── views/
│   │           └── history_view.dart        # UI: Calendar screen
│   │
│   ├── routes/                        # Navigation
│   │   ├── app_pages.dart                   # Route definitions
│   │   └── app_routes.dart                  # Route names
│   │
│   └── core/                          # Core utilities
│       └── config/
│           └── app_config.dart              # App configuration
│
└── main.dart                          # App entry point
```

---

## 💡 **Why This Architecture?**

### **Separation of Concerns**
```
View (UI)       → "What the user sees"
Controller      → "How things work"
Service         → "Where data comes from"
Model           → "What the data looks like"
```

### **Benefits**

| Benefit | Description | Example |
|---------|-------------|---------|
| **Testable** | Test logic without UI | `test('loads nutrition data', () { controller.loadNutritionForDate(...) })` |
| **Reusable** | Share controllers across screens | Multiple views can use same controller |
| **Maintainable** | Change UI without touching logic | Update colors/layout without changing controller |
| **Reactive** | UI auto-updates | Change `isLoading.value = true` → UI shows spinner |
| **Clean** | Each file has one responsibility | View only has UI, Controller only has logic |

---

## 🔍 **Real Example: Delete Flow**

### **1. User Action**
```dart
// history_view.dart
IconButton(
  icon: Icon(Icons.delete),
  onPressed: () => controller.deleteNutrition(item.id!),  // ← User taps
)
```

### **2. Controller Handles Logic**
```dart
// history_controller.dart
Future<void> deleteNutrition(int id) async {
  // Call service
  final success = await _nutritionService.deleteSavedNutrition(id);
  
  if (success) {
    // Update state
    savedNutritionList.removeWhere((item) => item.id == id);
    _calculateTotals();
    
    // Show feedback
    Get.snackbar('Success', 'Item deleted');
  }
}
```

### **3. Service Makes API Call**
```dart
// nutrition_service.dart
Future<bool> deleteSavedNutrition(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/save/$id'),
  );
  return response.statusCode == 200;
}
```

### **4. UI Auto-Updates**
```dart
// history_view.dart - Obx watches savedNutritionList
Obx(() => ListView.builder(
  itemCount: controller.savedNutritionList.length,  // ← Auto-updates!
  ...
))
```

---

## 📚 **Key GetX Concepts**

### **Reactive State**
```dart
// Create observable
final count = 0.obs;

// Update value
count.value = 5;  // UI auto-updates

// Observe in UI
Obx(() => Text('Count: ${count.value}'))
```

### **Dependency Injection**
```dart
// Put controller
Get.put(MyController());

// Use controller
class MyView extends GetView<MyController> {
  // 'controller' is automatically available
  controller.someMethod();
}
```

### **Navigation**
```dart
// Go to screen
Get.toNamed(AppRoutes.HISTORY);

// Go back
Get.back();

// Show snackbar
Get.snackbar('Title', 'Message');
```

---

## ✅ **Summary**

| Component | File | Purpose | Key Points |
|-----------|------|---------|------------|
| **Controller** | `*_controller.dart` | Business logic & state | Observable variables, async methods, calculations |
| **Binding** | `*_binding.dart` | Dependency injection | Creates controller, manages lifecycle |
| **View** | `*_view.dart` | UI display | Uses `Obx` for reactivity, calls controller methods |
| **Service** | `*_service.dart` | Data source | API calls, data fetching |
| **Model** | `*_model.dart` | Data structure | JSON parsing, data representation |

**The Golden Rule**: 
- View → Displays data
- Controller → Manages data
- Service → Fetches data
- Binding → Connects everything

This keeps your code **clean**, **testable**, and **maintainable**! 🎉
