# Contributing to CalPal 🥗

First off, thank you for considering contributing to CalPal! It's people like you that make CalPal such a great tool. 🎉

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Features](#suggesting-features)
  - [Code Contributions](#code-contributions)
- [Development Setup](#development-setup)
- [Code Style Guidelines](#code-style-guidelines)
- [Commit Message Guidelines](#commit-message-guidelines)
- [Pull Request Process](#pull-request-process)

---

## 📜 Code of Conduct

This project and everyone participating in it is governed by our commitment to providing a welcoming and inspiring community for all. By participating, you are expected to uphold this standard.

**Please be:**
- **Respectful** of differing viewpoints and experiences
- **Constructive** with your feedback
- **Collaborative** and supportive
- **Professional** in all interactions

---

## 🤝 How Can I Contribute?

### 🐛 Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**When submitting a bug report, include:**

- **Clear title and description**
- **Steps to reproduce** the issue
- **Expected behavior** vs actual behavior
- **Screenshots** if applicable
- **Device/Platform information:**
  - OS version
  - Flutter version
  - Device model (if relevant)
  - App version

**Example:**
```
**Bug**: Save button doesn't work on iOS

**Steps to Reproduce:**
1. Search for "apple"
2. Click the green "Save" button
3. No success message appears

**Expected**: Success snackbar and item saved
**Actual**: Nothing happens, no error shown

**Environment:**
- iOS 17.0
- iPhone 14 Pro
- Flutter 3.9.2
- CalPal v1.0.0
```

### 💡 Suggesting Features

We love feature suggestions! Before creating a feature request:

1. Check if the feature is already planned in [Future Plans](README.md#-future-plans)
2. Search existing issues to avoid duplicates
3. Consider if it fits CalPal's goals (simple, fast nutrition tracking)

**When suggesting a feature, include:**

- **Clear title and description**
- **Use case** - why is this useful?
- **Expected behavior** - how should it work?
- **Mockups or examples** (if applicable)

**Example:**
```
**Feature**: Add water intake tracking

**Use Case**: 
Users want to track water consumption alongside food intake for complete health tracking.

**Proposed Solution:**
- Add a "Water" tab in bottom navigation
- Simple counter with +/- buttons
- Daily goal setting (e.g., 8 glasses)
- Visual progress indicator
```

### 💻 Code Contributions

We welcome code contributions! Here's how to get started:

---

## 🛠️ Development Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub first, then:
git clone https://github.com/YOUR_USERNAME/calpal.git
cd calpal
```

### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Adding tests
- `chore/` - Maintenance tasks

### 3. Setup Development Environment

```bash
# Install Flutter dependencies
flutter pub get

# Setup backend (if needed)
cd backend
npm install
```

### 4. Make Your Changes

- Write clean, readable code
- Follow the existing architecture (MVC + GetX)
- Add comments for complex logic
- Update tests if applicable

### 5. Test Your Changes

```bash
# Run tests
flutter test

# Run the app
flutter run

# Check for errors
flutter analyze
```

---

## 📝 Code Style Guidelines

### Flutter/Dart Code Style

We follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style).

**Key points:**

```dart
// ✅ Good: Use descriptive names
final savedNutritionList = <SavedNutrition>[].obs;

// ❌ Bad: Unclear abbreviations
final snl = <SavedNutrition>[].obs;

// ✅ Good: Private methods start with underscore
void _calculateTotals() { ... }

// ✅ Good: Use const for constant widgets
const SizedBox(height: 16)

// ✅ Good: Organize imports
import 'dart:async';                    // Dart imports first
import 'package:flutter/material.dart'; // Flutter imports
import 'package:get/get.dart';          // Third-party packages
import '../models/nutrition_model.dart'; // Relative imports last
```

### Architecture Rules

1. **Controllers** - Business logic only, no UI
2. **Views** - UI only, no business logic
3. **Services** - API calls and data fetching
4. **Models** - Data structures and JSON parsing

**Example structure:**

```dart
// ✅ Good: Controller handles logic
class HomeController extends GetxController {
  Future<void> searchNutrition(String food) async {
    isLoading.value = true;
    final result = await _service.getNutritionInfo(food);
    nutritionData.value = result;
    isLoading.value = false;
  }
}

// ✅ Good: View displays data
class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
      ? CircularProgressIndicator()
      : NutritionCard(data: controller.nutritionData.value)
    );
  }
}
```

### File Naming

- Use snake_case for file names: `nutrition_service.dart`
- Match class names: `NutritionService` in `nutrition_service.dart`
- Group related files in folders

---

## 📋 Commit Message Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <subject>

<body (optional)>

<footer (optional)>
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding/updating tests
- `chore:` - Maintenance tasks

**Examples:**

```bash
# Good examples:
feat(history): add date range filter
fix(search): resolve timeout on slow networks
docs(readme): update installation instructions
refactor(controller): simplify data loading logic
test(home): add unit tests for search functionality

# With body:
feat(save): add confirmation dialog before deleting

Added a confirmation dialog when user clicks delete button
to prevent accidental deletions. Dialog shows item name
and has Cancel/Delete options.

Closes #45
```

---

## 🚀 Pull Request Process

### Before Submitting

1. **Update your branch** with latest main:
   ```bash
   git checkout main
   git pull upstream main
   git checkout your-branch
   git rebase main
   ```

2. **Run tests** and ensure they pass:
   ```bash
   flutter test
   flutter analyze
   ```

3. **Update documentation** if needed:
   - Update README.md for new features
   - Add/update code comments
   - Update ARCHITECTURE_GUIDE.md if architecture changes

### Submitting the PR

1. **Push your branch:**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request** on GitHub

3. **Fill out the PR template:**

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] Added new tests for this change
- [ ] Tested on Android emulator/device
- [ ] Tested on iOS simulator/device

## Screenshots (if applicable)
Add screenshots showing the changes

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
```

### Review Process

- A maintainer will review your PR
- Address any requested changes
- Once approved, your PR will be merged! 🎉

---

## 🧪 Testing Guidelines

### Writing Tests

```dart
// Example test structure
void main() {
  group('HomeController', () {
    late HomeController controller;
    
    setUp(() {
      controller = HomeController();
    });
    
    test('searchNutrition updates nutritionData', () async {
      await controller.searchNutrition('apple');
      expect(controller.nutritionData.value, isNotNull);
    });
    
    test('saveNutritionData shows success message', () async {
      controller.nutritionData.value = mockNutritionData;
      await controller.saveNutritionData();
      // Verify success snackbar shown
    });
  });
}
```

### Manual Testing Checklist

Before submitting, test:
- [ ] App builds without errors
- [ ] All screens load correctly
- [ ] Search functionality works
- [ ] Save functionality works
- [ ] History loads and displays data
- [ ] Delete functionality works
- [ ] Error handling displays properly
- [ ] Loading states show correctly

---

## 🎨 UI/UX Guidelines

When adding UI changes:

1. **Follow Material Design 3** guidelines
2. **Maintain consistency** with existing screens
3. **Use theme colors** (don't hardcode colors)
4. **Add loading states** for async operations
5. **Handle empty states** (no data scenarios)
6. **Show error messages** clearly
7. **Ensure responsiveness** (different screen sizes)

---

## ❓ Questions?

Feel free to:
- Open an issue with the `question` label
- Reach out to the maintainers
- Check existing documentation

---

## 🙏 Thank You!

Your contributions help make CalPal better for everyone! 

Every contribution, no matter how small, is valued and appreciated. ❤️

---

**Happy Coding!** 🚀
