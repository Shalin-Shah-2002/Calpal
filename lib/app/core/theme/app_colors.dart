import 'package:flutter/material.dart';

/// App color palette - Modern green theme
class AppColors {
  AppColors._();

  // Primary colors from palette
  static const Color midnightGreen = Color(0xFF114B5F); // Dark teal
  static const Color seaGreen = Color(0xFF1A936F); // Medium green
  static const Color celadon = Color(0xFF88D498); // Light green
  static const Color teaGreen = Color(0xFFC6DABF); // Very light green
  static const Color parchment = Color(0xFFF3E9D2); // Cream/beige

  // Semantic colors
  static const Color primary = seaGreen;
  static const Color primaryDark = midnightGreen;
  static const Color primaryLight = celadon;
  static const Color background = parchment;
  static const Color surface = Colors.white;
  static const Color surfaceLight = teaGreen;

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textOnPrimary = Colors.white;

  // Health score colors
  static const Color healthLow = Color(0xFFE74C3C); // Red
  static const Color healthMedium = Color(0xFFF39C12); // Orange
  static const Color healthHigh = seaGreen; // Green

  // Status colors
  static const Color success = seaGreen;
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = midnightGreen;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [midnightGreen, seaGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightGradient = LinearGradient(
    colors: [celadon, teaGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Colors.white, teaGreen],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: midnightGreen.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: seaGreen.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ======= GLASSMORPHISM EFFECTS =======

  // Glass Base Colors (with transparency)
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color glassLight = Color(0xFFF8FFFE);
  static const Color glassMint = Color(0xFFE8F5F0);
  static const Color glassTeal = Color(0xFFD4F1E8);

  // Glass Opacity Levels
  static const double glassOpacityHeavy = 0.25; // Heavy frosted cards
  static const double glassOpacityMedium = 0.15; // Standard containers
  static const double glassOpacityLight = 0.08; // Light overlays
  static const double glassOpacitySubtle = 0.05; // Subtle backgrounds

  // Blur Strengths (sigma values for BackdropFilter)
  static const double blurStrong = 20.0; // Heavy frosted effect
  static const double blurMedium = 12.0; // Standard glass blur
  static const double blurLight = 6.0; // Subtle glass effect
  static const double blurSubtle = 3.0; // Soft backdrop

  // Glass Border Highlights
  static Color glassBorderLight = glassWhite.withOpacity(0.3);
  static Color glassBorderMedium = glassWhite.withOpacity(0.5);
  static Color glassBorderStrong = glassWhite.withOpacity(0.7);

  // Glass Gradients (for liquid effects)
  static const LinearGradient glassGradientPrimary = LinearGradient(
    colors: [
      Color(0x40114B5F), // midnightGreen with 25% opacity
      Color(0x261A936F), // seaGreen with 15% opacity
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradientLight = LinearGradient(
    colors: [
      Color(0x2688D498), // celadon with 15% opacity
      Color(0x1AC6DABF), // teaGreen with 10% opacity
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradientWhite = LinearGradient(
    colors: [
      Color(0x40FFFFFF), // white with 25% opacity
      Color(0x1AFFFFFF), // white with 10% opacity
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer/Liquid Animation Gradient
  static const LinearGradient liquidShimmer = LinearGradient(
    colors: [Color(0x00FFFFFF), Color(0x40FFFFFF), Color(0x00FFFFFF)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
  );

  // Glass Shadow (softer, more diffused)
  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: midnightGreen.withOpacity(0.05),
      blurRadius: 24,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
    BoxShadow(
      color: seaGreen.withOpacity(0.03),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Elevated Glass Shadow (for floating elements)
  static List<BoxShadow> glassElevatedShadow = [
    BoxShadow(
      color: midnightGreen.withOpacity(0.08),
      blurRadius: 32,
      offset: const Offset(0, 12),
      spreadRadius: -8,
    ),
    BoxShadow(
      color: seaGreen.withOpacity(0.05),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
