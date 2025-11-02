import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/saved_nutrition_model.dart';
import '../controllers/history_controller.dart';
import '../../../core/widgets/modern_ui_components.dart';
import '../../../core/theme/app_colors.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildModernHeader(),
              ),
              _buildDateSelector(),
              _buildDailySummary(),
              Expanded(child: _buildNutritionList(bottomPadding)),
            ],
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
            Icons.calendar_today_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Flexible(
                    child: Text(
                      'Nutrition History',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Live indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Text(
                'Auto-refreshing every 5s',
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

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ModernCard(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final date = controller.selectedDate.value;
          final isToday = _isToday(date);
          final formattedDate = DateFormat('EEEE, MMM d, yyyy').format(date);

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: controller.previousDay,
                      icon: const Icon(Icons.chevron_left_rounded, size: 28),
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isToday)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.grey[200]
                          : AppColors.primaryLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: !isToday ? controller.nextDay : null,
                      icon: const Icon(Icons.chevron_right_rounded, size: 28),
                      color: isToday ? Colors.grey[400] : AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (!isToday) ...[
                const SizedBox(height: 12),
                ModernButton(
                  text: 'Jump to Today',
                  icon: Icons.today_rounded,
                  onPressed: controller.goToToday,
                  gradient: AppColors.primaryGradient,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDailySummary() {
    return Obx(() {
      if (controller.savedNutritionList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ModernCard(
          padding: const EdgeInsets.all(20),
          gradient: AppColors.primaryGradient,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Daily Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildModernSummaryItem(
                    'Calories',
                    controller.totalCalories.value.toStringAsFixed(0),
                    'kcal',
                    Icons.local_fire_department_rounded,
                  ),
                  _buildModernSummaryItem(
                    'Protein',
                    controller.totalProtein.value.toStringAsFixed(1),
                    'g',
                    Icons.fitness_center_rounded,
                  ),
                  _buildModernSummaryItem(
                    'Carbs',
                    controller.totalCarbs.value.toStringAsFixed(1),
                    'g',
                    Icons.grain_rounded,
                  ),
                  _buildModernSummaryItem(
                    'Fats',
                    controller.totalFats.value.toStringAsFixed(1),
                    'g',
                    Icons.opacity_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildModernSummaryItem(
    String label,
    String value,
    String unit,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                unit,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }



  Widget _buildNutritionList(double bottomPadding) {
    return Obx(() {
      if (controller.isLoading.value && controller.savedNutritionList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading nutrition data...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      if (controller.savedNutritionList.isEmpty) {
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            controller.refreshData();
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(Get.context!).size.height * 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No meals logged',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start tracking your nutrition!',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pull down to refresh',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          controller.refreshData();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: bottomPadding,
          ),
          itemCount: controller.savedNutritionList.length,
          itemBuilder: (context, index) {
            final nutrition = controller.savedNutritionList[index];
            return _buildModernNutritionCard(nutrition);
          },
        ),
      );
    });
  }

  Widget _buildModernNutritionCard(SavedNutrition nutrition) {
    return ModernCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      onTap: () => _showNutritionDetails(nutrition),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Health Score Badge
              if (nutrition.healthyScore != null)
                HealthScoreBadge(
                  score: nutrition.healthyScore!,
                  size: 50,
                ),
              if (nutrition.healthyScore != null) const SizedBox(width: 16),
              // Food Name and Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nutrition.foodName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          nutrition.createdAt != null
                              ? DateFormat('h:mm a')
                                  .format(nutrition.createdAt!.toLocal())
                              : 'Unknown',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete Button
              Container(
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () => _confirmDelete(nutrition),
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: AppColors.error,
                  iconSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Serving Size
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.straighten_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Serving: ${nutrition.servingSize}g',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Quick Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildModernQuickStat(
                  Icons.local_fire_department_rounded,
                  nutrition.calories.toStringAsFixed(0),
                  'kcal',
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              if (nutrition.macronutrients?.proteinG != null)
                Expanded(
                  child: _buildModernQuickStat(
                    Icons.fitness_center_rounded,
                    nutrition.macronutrients!.proteinG!.toStringAsFixed(1),
                    'g protein',
                    Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernQuickStat(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _showNutritionDetails(SavedNutrition nutrition) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      nutrition.foodName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),

              // Macronutrients
              if (nutrition.macronutrients != null) ...[
                const Text(
                  'Macronutrients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Protein',
                  nutrition.macronutrients!.proteinG,
                  'g',
                ),
                _buildDetailRow(
                  'Carbs',
                  nutrition.macronutrients!.carbohydratesG,
                  'g',
                ),
                _buildDetailRow('Fats', nutrition.macronutrients!.fatsG, 'g'),
                if (nutrition.macronutrients!.fiberG != null)
                  _buildDetailRow(
                    'Fiber',
                    nutrition.macronutrients!.fiberG,
                    'g',
                  ),
                if (nutrition.macronutrients!.sugarsG != null)
                  _buildDetailRow(
                    'Sugars',
                    nutrition.macronutrients!.sugarsG,
                    'g',
                  ),
                const SizedBox(height: 16),
              ],

              // Notes
              if (nutrition.notes != null && nutrition.notes!.isNotEmpty) ...[
                const Text(
                  'Health Notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    nutrition.notes!,
                    style: TextStyle(color: Colors.green[900]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(String label, double? value, String unit) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            '${value.toStringAsFixed(1)} $unit',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(SavedNutrition nutrition) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Item'),
        content: Text(
          'Are you sure you want to delete "${nutrition.foodName}"?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              if (nutrition.id != null) {
                controller.deleteNutrition(nutrition.id!);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
