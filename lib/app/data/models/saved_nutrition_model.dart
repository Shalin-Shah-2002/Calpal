class SavedNutrition {
  final int? id;
  final String foodName;
  final String servingSize;
  final double calories;
  final Macronutrients? macronutrients;
  final Micronutrients? micronutrients;
  final int? healthyScore;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SavedNutrition({
    this.id,
    required this.foodName,
    required this.servingSize,
    required this.calories,
    this.macronutrients,
    this.micronutrients,
    this.healthyScore,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory SavedNutrition.fromJson(Map<String, dynamic> json) {
    // Backend returns nutrients as flat fields, we need to build the nested objects
    final macros = Macronutrients(
      proteinG: _parseDouble(json['protein_g']),
      carbohydratesG: _parseDouble(json['carbohydrates_g']),
      fatsG: _parseDouble(json['fats_g']),
      fiberG: _parseDouble(json['fiber_g']),
      sugarsG: _parseDouble(json['sugars_g']),
    );

    final micros = Micronutrients(
      sodiumMg: _parseDouble(json['sodium_mg']),
      potassiumMg: _parseDouble(json['potassium_mg']),
      calciumMg: _parseDouble(json['calcium_mg']),
      ironMg: _parseDouble(json['iron_mg']),
      vitaminCMg: _parseDouble(json['vitamin_c_mg']),
      vitaminDMcg: _parseDouble(json['vitamin_d_mcg']),
      vitaminB12Mcg: _parseDouble(json['vitamin_b12_mcg']),
    );

    return SavedNutrition(
      id: json['id'],
      foodName: json['food_name'] ?? '',
      servingSize: json['serving_size']?.toString() ?? '',
      calories: _parseDouble(json['calories']) ?? 0,
      macronutrients: macros,
      micronutrients: micros,
      healthyScore: json['healthy_score'] is int
          ? json['healthy_score']
          : int.tryParse(json['healthy_score']?.toString() ?? ''),
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'food_name': foodName,
      'serving_size': servingSize,
      'calories': calories,
      'macronutrients': macronutrients?.toJson(),
      'micronutrients': micronutrients?.toJson(),
      'healthy_score': healthyScore,
      'notes': notes,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
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
      proteinG: _parseDouble(json['protein_g'] ?? json['proteinG']),
      carbohydratesG: _parseDouble(
        json['carbohydrates_g'] ?? json['carbohydratesG'],
      ),
      fatsG: _parseDouble(json['fats_g'] ?? json['fatsG']),
      fiberG: _parseDouble(json['fiber_g'] ?? json['fiberG']),
      sugarsG: _parseDouble(json['sugars_g'] ?? json['sugarsG']),
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
      sodiumMg: _parseDouble(json['sodium_mg'] ?? json['sodiumMg']),
      potassiumMg: _parseDouble(json['potassium_mg'] ?? json['potassiumMg']),
      calciumMg: _parseDouble(json['calcium_mg'] ?? json['calciumMg']),
      ironMg: _parseDouble(json['iron_mg'] ?? json['ironMg']),
      vitaminCMg: _parseDouble(json['vitamin_c_mg'] ?? json['vitaminCMg']),
      vitaminDMcg: _parseDouble(json['vitamin_d_mcg'] ?? json['vitaminDMcg']),
      vitaminB12Mcg: _parseDouble(
        json['vitamin_b12_mcg'] ?? json['vitaminB12Mcg'],
      ),
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
