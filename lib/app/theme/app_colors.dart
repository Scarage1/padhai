import 'package:flutter/material.dart';

/// Application color palette
/// DO NOT MODIFY - Locked by DOC-006
abstract class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF4F46E5);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Emerald
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryDark = Color(0xFF059669);

  // Subject Colors
  static const Color science = Color(0xFF4CAF50); // Green
  static const Color maths = Color(0xFF2196F3); // Blue

  // Semantic Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Difficulty Colors
  static const Color beginner = Color(0xFF22C55E); // Green
  static const Color intermediate = Color(0xFFF59E0B); // Amber
  static const Color advanced = Color(0xFFEF4444); // Red

  // Quiz Colors
  static const Color correct = Color(0xFF22C55E);
  static const Color incorrect = Color(0xFFEF4444);
  static const Color skipped = Color(0xFF94A3B8);
  static const Color selected = Color(0xFF6366F1);
}
