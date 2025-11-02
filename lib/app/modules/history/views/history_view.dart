import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/saved_nutrition_model.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Nutrition History'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          _buildDailySummary(),
          Expanded(child: _buildNutritionList()),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        final date = controller.selectedDate.value;
        final isToday = _isToday(date);
        final formattedDate = DateFormat('EEEE, MMM d, yyyy').format(date);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.previousDay,
                  icon: const Icon(Icons.chevron_left, size: 32),
                  color: Colors.green[700],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (isToday)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Today',
                            style: TextStyle(
                              color: Colors.green[900],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: !isToday ? controller.nextDay : null,
                  icon: const Icon(Icons.chevron_right, size: 32),
                  color: isToday ? Colors.grey : Colors.green[700],
                ),
              ],
            ),
            if (!isToday) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: controller.goToToday,
                icon: const Icon(Icons.today, size: 16),
                label: const Text('Go to Today'),
                style: TextButton.styleFrom(foregroundColor: Colors.green[700]),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildDailySummary() {
    return Obx(() {
      if (controller.savedNutritionList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[600]!],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Summary',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Calories',
                  controller.totalCalories.value.toStringAsFixed(0),
                  'kcal',
                  Icons.local_fire_department,
                ),
                _buildSummaryItem(
                  'Protein',
                  controller.totalProtein.value.toStringAsFixed(1),
                  'g',
                  Icons.fitness_center,
                ),
                _buildSummaryItem(
                  'Carbs',
                  controller.totalCarbs.value.toStringAsFixed(1),
                  'g',
                  Icons.grain,
                ),
                _buildSummaryItem(
                  'Fats',
                  controller.totalFats.value.toStringAsFixed(1),
                  'g',
                  Icons.opacity,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    String unit,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          '$value $unit',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.savedNutritionList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'No meals logged for this day',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start tracking your nutrition!',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.savedNutritionList.length,
        itemBuilder: (context, index) {
          final nutrition = controller.savedNutritionList[index];
          return _buildNutritionCard(nutrition);
        },
      );
    });
  }

  Widget _buildNutritionCard(SavedNutrition nutrition) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showNutritionDetails(nutrition),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Health Score Badge
                  if (nutrition.healthyScore != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getScoreColor(nutrition.healthyScore!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            '${nutrition.healthyScore}/10',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Delete Button
                  IconButton(
                    onPressed: () => _confirmDelete(nutrition),
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red[400],
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Food Name
              Text(
                nutrition.foodName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Serving: ${nutrition.servingSize}g',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              // Quick Stats
              Row(
                children: [
                  _buildQuickStat(
                    Icons.local_fire_department,
                    '${nutrition.calories.toStringAsFixed(0)} kcal',
                    Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  if (nutrition.macronutrients?.proteinG != null)
                    _buildQuickStat(
                      Icons.fitness_center,
                      '${nutrition.macronutrients!.proteinG!.toStringAsFixed(1)}g protein',
                      Colors.red,
                    ),
                ],
              ),
              if (nutrition.createdAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Added at ${DateFormat('h:mm a').format(nutrition.createdAt!.toLocal())}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.lightGreen;
    if (score >= 4) return Colors.orange;
    return Colors.red;
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
