import 'package:flutter/material.dart';

class AppShadow {

  // =========================
  // Light
  // =========================

  static List<BoxShadow> light = [

    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),

  ];

  // =========================
  // Medium
  // =========================

  static List<BoxShadow> medium = [

    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),

  ];

  // =========================
  // Large
  // =========================

  static List<BoxShadow> large = [

    BoxShadow(
      color: Colors.black.withValues(alpha: 0.18),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),

  ];

}