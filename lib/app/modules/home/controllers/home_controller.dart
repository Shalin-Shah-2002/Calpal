import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/nutrition_model.dart';
import '../../../data/services/nutrition_service.dart';

class HomeController extends GetxController {
  final NutritionService _nutritionService = NutritionService();

  // Observable variables
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final nutritionData = Rx<NutritionModel?>(null);
  final searchHistory = <String>[].obs;

  // Error handling
  final errorMessage = ''.obs;
  final isSaving = false.obs;
  final saveSuccess = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSearchHistory();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Search for nutrition information
  Future<void> searchNutrition(String food) async {
    if (food.trim().isEmpty) {
      errorMessage.value = 'Please enter a food item';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      nutritionData.value = null;

      final result = await _nutritionService.getNutritionInfo(food.trim());

      if (result.error != null) {
        errorMessage.value = result.error!;
      } else {
        nutritionData.value = result;
        _addToSearchHistory(food.trim());
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Search from button press
  void onSearchPressed() {
    searchNutrition(searchController.text);
  }

  /// Clear search results
  void clearSearch() {
    searchController.clear();
    nutritionData.value = null;
    errorMessage.value = '';
  }

  /// Add to search history
  void _addToSearchHistory(String food) {
    if (!searchHistory.contains(food)) {
      searchHistory.insert(0, food);
      if (searchHistory.length > 10) {
        searchHistory.removeRange(10, searchHistory.length);
      }
      // In a real app, you would save this to local storage
    }
  }

  /// Load search history from storage
  void _loadSearchHistory() {
    // In a real app, you would load this from local storage
    // For now, it's just an empty list
  }

  /// Search from history
  void searchFromHistory(String food) {
    searchController.text = food;
    searchNutrition(food);
  }

  /// Clear search history
  void clearHistory() {
    searchHistory.clear();
  }

  /// Check if server is reachable
  Future<bool> checkServerConnection() async {
    return await _nutritionService.checkServerHealth();
  }

  /// Save current nutrition data to database
  Future<void> saveNutritionData() async {
    if (nutritionData.value == null) {
      Get.snackbar(
        'Error',
        'No nutrition data to save',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      isSaving.value = true;
      final result = await _nutritionService.saveNutrition(
        nutritionData.value!,
      );

      if (result != null) {
        Get.snackbar(
          'Success',
          '${nutritionData.value!.foodName} saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          icon: const Icon(Icons.check_circle, color: Colors.green),
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to save nutrition data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isSaving.value = false;
    }
  }
}
