import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/saved_nutrition_model.dart';
import '../../../data/services/nutrition_service.dart';
import 'package:flutter/material.dart';

class HistoryController extends GetxController {
  final NutritionService _nutritionService = NutritionService();

  final selectedDate = DateTime.now().obs;
  final savedNutritionList = <SavedNutrition>[].obs;
  final isLoading = false.obs;
  final totalCalories = 0.0.obs;
  final totalProtein = 0.0.obs;
  final totalCarbs = 0.0.obs;
  final totalFats = 0.0.obs;
  
  // Stream subscription for real-time updates
  StreamSubscription<List<SavedNutrition>>? _nutritionSubscription;

  @override
  void onInit() {
    super.onInit();
    _startStreamForDate(selectedDate.value);
  }
  
  @override
  void onClose() {
    _nutritionSubscription?.cancel();
    _nutritionService.dispose();
    super.onClose();
  }

  /// Start real-time stream for a specific date
  void _startStreamForDate(DateTime date) {
    try {
      isLoading.value = true;
      selectedDate.value = date;
      
      // Cancel previous subscription
      _nutritionSubscription?.cancel();
      
      // Subscribe to nutrition stream
      _nutritionSubscription = _nutritionService
          .getNutritionStreamForDate(date)
          .listen(
        (data) {
          // Update UI with new data
          savedNutritionList.value = data;
          _calculateTotals();
          isLoading.value = false;
        },
        onError: (error) {
          isLoading.value = false;
          Get.snackbar(
            'Error',
            'Failed to load nutrition data',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[900],
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to start real-time updates',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }
  
  /// Load nutrition data for a specific date (backward compatibility)
  Future<void> loadNutritionForDate(DateTime date) async {
    _startStreamForDate(date);
  }
  
  /// Manually refresh current date
  void refreshData() {
    _nutritionService.refreshCurrentDate();
  }

  /// Delete a nutrition entry
  Future<void> deleteNutrition(int id) async {
    try {
      final success = await _nutritionService.deleteSavedNutrition(id);
      if (success) {
        savedNutritionList.removeWhere((item) => item.id == id);
        _calculateTotals();
        Get.snackbar(
          'Success',
          'Item deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete item',
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
    }
  }

  /// Calculate daily totals
  void _calculateTotals() {
    totalCalories.value = savedNutritionList.fold(
      0.0,
      (sum, item) => sum + item.calories,
    );

    totalProtein.value = savedNutritionList.fold(
      0.0,
      (sum, item) => sum + (item.macronutrients?.proteinG ?? 0),
    );

    totalCarbs.value = savedNutritionList.fold(
      0.0,
      (sum, item) => sum + (item.macronutrients?.carbohydratesG ?? 0),
    );

    totalFats.value = savedNutritionList.fold(
      0.0,
      (sum, item) => sum + (item.macronutrients?.fatsG ?? 0),
    );
  }

  /// Change selected date
  void changeDate(DateTime date) {
    _startStreamForDate(date);
  }

  /// Go to previous day
  void previousDay() {
    final newDate = selectedDate.value.subtract(const Duration(days: 1));
    changeDate(newDate);
  }

  /// Go to next day
  void nextDay() {
    final newDate = selectedDate.value.add(const Duration(days: 1));
    changeDate(newDate);
  }

  /// Go to today
  void goToToday() {
    changeDate(DateTime.now());
  }
}
