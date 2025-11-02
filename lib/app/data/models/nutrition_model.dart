class NutritionModel {
  final String foodName;
  final String servingSize;
  final double? calories;
  final Macronutrients? macronutrients;
  final Micronutrients? micronutrients;
  final int? healthyScore;
  final String? notes;
  final String? error;

  NutritionModel({
    required this.foodName,
    required this.servingSize,
    this.calories,
    this.macronutrients,
    this.micronutrients,
    this.healthyScore,
    this.notes,
    this.error,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    // Handle error response
    if (json['error'] != null) {
      return NutritionModel(
        foodName: '',
        servingSize: '',
        error: json['error'],
      );
    }

    return NutritionModel(
      foodName: json['food_name'] ?? '',
      servingSize: json['serving_size']?.toString() ?? '100g',
      calories: _parseDouble(json['calories']),
      macronutrients: json['macronutrients'] != null
          ? Macronutrients.fromJson(json['macronutrients'])
          : null,
      micronutrients: json['micronutrients'] != null
          ? Micronutrients.fromJson(json['micronutrients'])
          : null,
      healthyScore: json['healthy_score'] is int
          ? json['healthy_score']
          : int.tryParse(json['healthy_score']?.toString() ?? ''),
      notes: json['notes'],
      error: null,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'food_name': foodName,
      'serving_size': servingSize,
      'calories': calories,
      'macronutrients': macronutrients?.toJson(),
      'micronutrients': micronutrients?.toJson(),
      'healthy_score': healthyScore,
      'notes': notes,
      'error': error,
    };
  }
}

class Macronutrients {
  final double? proteinG;
  final double? carbohydratesG;
  final double? fatsG;
  final double? fiberG;
  final double? sugarsG;

  Macronutrients({
    this.proteinG,
    this.carbohydratesG,
    this.fatsG,
    this.fiberG,
    this.sugarsG,
  });

  factory Macronutrients.fromJson(Map<String, dynamic> json) {
    return Macronutrients(
      proteinG: _parseDouble(json['protein_g']),
      carbohydratesG: _parseDouble(json['carbohydrates_g']),
      fatsG: _parseDouble(json['fats_g']),
      fiberG: _parseDouble(json['fiber_g']),
      sugarsG: _parseDouble(json['sugars_g']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'protein_g': proteinG,
      'carbohydrates_g': carbohydratesG,
      'fats_g': fatsG,
      'fiber_g': fiberG,
      'sugars_g': sugarsG,
    };
  }
}

class Micronutrients {
  final double? sodiumMg;
  final double? potassiumMg;
  final double? calciumMg;
  final double? ironMg;
  final double? vitaminCMg;
  final double? vitaminDMcg;
  final double? vitaminB12Mcg;

  Micronutrients({
    this.sodiumMg,
    this.potassiumMg,
    this.calciumMg,
    this.ironMg,
    this.vitaminCMg,
    this.vitaminDMcg,
    this.vitaminB12Mcg,
  });

  factory Micronutrients.fromJson(Map<String, dynamic> json) {
    return Micronutrients(
      sodiumMg: _parseDouble(json['sodium_mg']),
      potassiumMg: _parseDouble(json['potassium_mg']),
      calciumMg: _parseDouble(json['calcium_mg']),
      ironMg: _parseDouble(json['iron_mg']),
      vitaminCMg: _parseDouble(json['vitamin_c_mg']),
      vitaminDMcg: _parseDouble(json['vitamin_d_mcg']),
      vitaminB12Mcg: _parseDouble(json['vitamin_b12_mcg']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'sodium_mg': sodiumMg,
      'potassium_mg': potassiumMg,
      'calcium_mg': calciumMg,
      'iron_mg': ironMg,
      'vitamin_c_mg': vitaminCMg,
      'vitamin_d_mcg': vitaminDMcg,
      'vitamin_b12_mcg': vitaminB12Mcg,
    };
  }
}
