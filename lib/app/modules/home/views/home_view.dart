import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/widgets/modern_ui_components.dart';
import '../../../core/theme/app_colors.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate safe bottom padding for floating nav bar
    final bottomPadding = MediaQuery.of(context).padding.bottom + 115.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.teaGreen.withOpacity(0.3),
              Colors.white,
              AppColors.celadon.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false, // Don't apply safe area to bottom
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildModernHeader(),
                  const SizedBox(height: 24),
                  _buildSearchSection(),
                  const SizedBox(height: 24),
                  _buildResultSection(),
                  const SizedBox(height: 24),
                  _buildSearchHistorySection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant_menu_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CalPal',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Your nutrition companion',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModernSectionHeader(
            title: 'Find Nutrition',
            subtitle: 'Search any food to see its nutritional value',
            icon: Icons.search_rounded,
          ),
          const SizedBox(height: 20),
          ModernSearchBar(
            controller: controller.searchController,
            hintText: 'e.g., 2 boiled eggs, chicken breast',
            onSearch: controller.onSearchPressed,
            onSubmitted: (value) => controller.onSearchPressed(),
          ),
          const SizedBox(height: 16),
          Obx(() => controller.isLoading.value
              ? Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Analyzing nutrition...',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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
    );
  }

  Widget _buildResultSection() {
    return Obx(() {
      final data = controller.nutritionData.value;

      if (data == null) {
        return const SizedBox.shrink();
      }

      return ModernCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NUTRITION DETAILS',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.foodName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: controller.clearSearch,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Health Score & Save Button Row
            Row(
              children: [
                if (data.healthyScore != null) ...[
                  HealthScoreBadge(score: data.healthyScore!),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Serving Size',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.servingSize}g',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => ModernButton(
                    text: 'Save',
                    icon: Icons.bookmark_rounded,
                    onPressed: controller.saveNutritionData,
                    isLoading: controller.isSaving.value,
                    gradient: AppColors.primaryGradient,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Macronutrients Grid
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryLight.withOpacity(0.2),
                    AppColors.teaGreen.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MACRONUTRIENTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildModernNutrientRow(
                    'Calories',
                    (data.calories ?? 0).toStringAsFixed(0),
                    'kcal',
                    Icons.local_fire_department_rounded,
                    Colors.orange,
                  ),
                  if (data.macronutrients != null) ...[
                    _buildModernNutrientRow(
                      'Protein',
                      data.macronutrients!.proteinG?.toStringAsFixed(1) ?? '0',
                      'g',
                      Icons.fitness_center_rounded,
                      Colors.red,
                    ),
                    _buildModernNutrientRow(
                      'Carbs',
                      data.macronutrients!.carbohydratesG?.toStringAsFixed(1) ?? '0',
                      'g',
                      Icons.grain_rounded,
                      Colors.brown,
                    ),
                    _buildModernNutrientRow(
                      'Fats',
                      data.macronutrients!.fatsG?.toStringAsFixed(1) ?? '0',
                      'g',
                      Icons.opacity_rounded,
                      Colors.amber[700]!,
                    ),
                  ],
                ],
              ),
            ),

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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.info.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_rounded,
                      color: AppColors.info,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        data.notes!,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildModernNutrientRow(
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            unit,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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

      return ModernCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModernSectionHeader(
              title: 'Recent Searches',
              subtitle: 'Tap to search again',
              icon: Icons.history_rounded,
              actionText: 'Clear All',
              onActionTap: controller.clearHistory,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.searchHistory
                  .map(
                    (food) => ModernTag(
                      text: food,
                      icon: Icons.restaurant_rounded,
                      onTap: () => controller.searchFromHistory(food),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    });
  }

  /// Get gradient colors based on health score
}
