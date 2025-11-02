import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nutrition_model.dart';
import '../models/saved_nutrition_model.dart';
import '../../core/config/app_config.dart';

class NutritionService {
  // Base URL for the nutrition API from config
  static String get baseUrl => AppConfig.apiBaseUrl;

  /// Fetches nutrition information for a given food item
  ///
  /// [food] - The food description (e.g., "2 boiled eggs")
  /// Returns a [NutritionModel] with the nutrition information or error
  Future<NutritionModel> getNutritionInfo(String food) async {
    try {
      final url = Uri.parse('$baseUrl/nutrition');
      print('🔍 Attempting to fetch nutrition from: $url');
      print('📦 Request body: ${jsonEncode({'food': food})}');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'food': food}),
          )
          .timeout(
            AppConfig.apiTimeout,
            onTimeout: () {
              print(
                '⏱️ Request timed out after ${AppConfig.apiTimeout.inSeconds} seconds',
              );
              throw Exception(
                'Request timeout - Backend not responding. Check if server is running and URL is correct.',
              );
            },
          );

      print('✅ Response received: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return NutritionModel.fromJson(data);
      } else if (response.statusCode == 400) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);
          return NutritionModel(
            foodName: food,
            servingSize: '',
            error: data['error'] ?? 'Bad request',
          );
        } catch (e) {
          return NutritionModel(
            foodName: food,
            servingSize: '',
            error: 'Bad request: ${response.body}',
          );
        }
      } else if (response.statusCode == 403) {
        return NutritionModel(
          foodName: food,
          servingSize: '',
          error:
              'Access forbidden. Check your backend API permissions or CORS settings.',
        );
      } else if (response.statusCode == 404) {
        return NutritionModel(
          foodName: food,
          servingSize: '',
          error:
              'API endpoint not found. Check that /nutrition exists on your backend.',
        );
      } else {
        // Try to parse error message from response
        String errorMsg = 'Server error: ${response.statusCode}';
        try {
          final data = jsonDecode(response.body);
          if (data['error'] != null) {
            errorMsg = data['error'];
          }
        } catch (e) {
          // If can't parse, just use the status code
          errorMsg += ' - ${response.body}';
        }
        return NutritionModel(foodName: food, servingSize: '', error: errorMsg);
      }
    } catch (e) {
      return NutritionModel(
        foodName: food,
        servingSize: '',
        error: 'Failed to fetch nutrition data: ${e.toString()}',
      );
    }
  }

  /// Validates if the backend server is reachable
  Future<bool> checkServerHealth() async {
    try {
      final url = Uri.parse('$baseUrl/health');
      final response = await http.get(url).timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Save nutrition data to database
  Future<SavedNutrition?> saveNutrition(NutritionModel nutrition) async {
    try {
      final url = Uri.parse('$baseUrl/save');

      final requestBody = {
        'food_name': nutrition.foodName,
        'serving_size': nutrition.servingSize,
        'calories': nutrition.calories,
        'macronutrients': nutrition.macronutrients?.toJson(),
        'micronutrients': nutrition.micronutrients?.toJson(),
        'healthy_score': nutrition.healthyScore,
        'notes': nutrition.notes,
      };

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(AppConfig.apiTimeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return SavedNutrition.fromJson(data);
      } else {
        print(
          'Error saving nutrition: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('Exception saving nutrition: $e');
      return null;
    }
  }

  /// Get all saved nutrition records for a specific date
  /// Uses endpoint: GET /save/date/YYYY-MM-DD
  Future<List<SavedNutrition>> getSavedNutritionByDate(DateTime date) async {
    try {
      final formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final url = Uri.parse('$baseUrl/save/date/$formattedDate');

      print('📅 Fetching nutrition data for date: $formattedDate');
      print('🔍 URL: $url');

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(AppConfig.apiTimeout);

      print('✅ Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Backend returns: { "success": true, "date": "2025-11-02", "count": 6, "data": [...] }
        if (responseBody['success'] == true && responseBody['data'] != null) {
          final List<dynamic> data = responseBody['data'];
          print('📦 Found ${data.length} nutrition records');
          return data.map((json) => SavedNutrition.fromJson(json)).toList();
        }

        return [];
      } else {
        print('❌ Error fetching nutrition: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Exception fetching nutrition: $e');
      return [];
    }
  }

  /// Delete a saved nutrition record
  Future<bool> deleteSavedNutrition(int id) async {
    try {
      final url = Uri.parse('$baseUrl/save/$id');

      final response = await http
          .delete(url, headers: {'Content-Type': 'application/json'})
          .timeout(AppConfig.apiTimeout);

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Exception deleting nutrition: $e');
      return false;
    }
  }
}
