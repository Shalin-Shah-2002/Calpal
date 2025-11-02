import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CalPal - Nutrition Search'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchSection(),
              const SizedBox(height: 20),
              _buildResultSection(),
              const SizedBox(height: 20),
              _buildSearchHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search for Food',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'e.g., 2 boiled eggs',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onSubmitted: (value) => controller.onSearchPressed(),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.onSearchPressed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Search'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.errorMessage.value.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return Obx(() {
      final data = controller.nutritionData.value;

      if (data == null) {
        return const SizedBox.shrink();
      }

      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Nutrition Info for: ${data.foodName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Save Button
                      Obx(
                        () => ElevatedButton.icon(
                          onPressed: controller.isSaving.value
                              ? null
                              : controller.saveNutritionData,
                          icon: controller.isSaving.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.add, size: 20),
                          label: const Text('Save'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: controller.clearSearch,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              // Health Score
              if (data.healthyScore != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getHealthScoreGradient(data.healthyScore!),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.health_and_safety, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Health Score',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${data.healthyScore}/10',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Serving Size
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.straighten, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Serving Size: ${data.servingSize}g',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Calories
              _buildNutritionRow(
                'Calories',
                data.calories,
                'kcal',
                Icons.local_fire_department,
                Colors.orange,
              ),

              // Macronutrients
              if (data.macronutrients != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Macronutrients',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildNutritionRow(
                  'Protein',
                  data.macronutrients!.proteinG,
                  'g',
                  Icons.fitness_center,
                  Colors.red,
                ),
                _buildNutritionRow(
                  'Carbohydrates',
                  data.macronutrients!.carbohydratesG,
                  'g',
                  Icons.grain,
                  Colors.brown,
                ),
                _buildNutritionRow(
                  'Fats',
                  data.macronutrients!.fatsG,
                  'g',
                  Icons.opacity,
                  Colors.yellow[700]!,
                ),
                if (data.macronutrients!.fiberG != null)
                  _buildNutritionRow(
                    'Fiber',
                    data.macronutrients!.fiberG,
                    'g',
                    Icons.spa,
                    Colors.green,
                  ),
                if (data.macronutrients!.sugarsG != null)
                  _buildNutritionRow(
                    'Sugars',
                    data.macronutrients!.sugarsG,
                    'g',
                    Icons.cake,
                    Colors.pink,
                  ),
              ],

              // Micronutrients
              if (data.micronutrients != null) ...[
                const SizedBox(height: 16),
                ExpansionTile(
                  title: const Text(
                    'Micronutrients & Vitamins',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    if (data.micronutrients!.sodiumMg != null)
                      _buildNutritionRow(
                        'Sodium',
                        data.micronutrients!.sodiumMg,
                        'mg',
                        Icons.water_drop,
                        Colors.blue,
                      ),
                    if (data.micronutrients!.potassiumMg != null)
                      _buildNutritionRow(
                        'Potassium',
                        data.micronutrients!.potassiumMg,
                        'mg',
                        Icons.bolt,
                        Colors.amber,
                      ),
                    if (data.micronutrients!.calciumMg != null)
                      _buildNutritionRow(
                        'Calcium',
                        data.micronutrients!.calciumMg,
                        'mg',
                        Icons.medication,
                        Colors.grey,
                      ),
                    if (data.micronutrients!.ironMg != null)
                      _buildNutritionRow(
                        'Iron',
                        data.micronutrients!.ironMg,
                        'mg',
                        Icons.battery_charging_full,
                        Colors.red[900]!,
                      ),
                    if (data.micronutrients!.vitaminCMg != null)
                      _buildNutritionRow(
                        'Vitamin C',
                        data.micronutrients!.vitaminCMg,
                        'mg',
                        Icons.local_florist,
                        Colors.orange[700]!,
                      ),
                    if (data.micronutrients!.vitaminDMcg != null)
                      _buildNutritionRow(
                        'Vitamin D',
                        data.micronutrients!.vitaminDMcg,
                        'mcg',
                        Icons.wb_sunny,
                        Colors.yellow[600]!,
                      ),
                    if (data.micronutrients!.vitaminB12Mcg != null)
                      _buildNutritionRow(
                        'Vitamin B12',
                        data.micronutrients!.vitaminB12Mcg,
                        'mcg',
                        Icons.energy_savings_leaf,
                        Colors.green[700]!,
                      ),
                  ],
                ),
              ],

              // Notes
              if (data.notes != null && data.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          data.notes!,
                          style: TextStyle(color: Colors.green[900]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNutritionRow(
    String label,
    double? value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value != null ? '${value.toStringAsFixed(1)} $unit' : 'N/A',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistorySection() {
    return Obx(() {
      if (controller.searchHistory.isEmpty) {
        return const SizedBox.shrink();
      }

      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Searches',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: controller.clearHistory,
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const Divider(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.searchHistory
                    .map(
                      (food) => ActionChip(
                        avatar: const Icon(Icons.history, size: 18),
                        label: Text(food),
                        onPressed: () => controller.searchFromHistory(food),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Get gradient colors based on health score
  List<Color> _getHealthScoreGradient(int score) {
    if (score >= 8) {
      return [Colors.green[600]!, Colors.green[400]!];
    } else if (score >= 6) {
      return [Colors.lightGreen[600]!, Colors.lightGreen[400]!];
    } else if (score >= 4) {
      return [Colors.orange[600]!, Colors.orange[400]!];
    } else {
      return [Colors.red[600]!, Colors.red[400]!];
    }
  }
}
