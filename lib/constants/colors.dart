import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  
  // Background Colors
  static const Color background = Color(0xFF0F172A); // Dark blue-gray
  static const Color backgroundLight = Color(0xFF1E293B);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textTertiary = Color(0xFF94A3B8);
  
  // Accent Colors
  static const Color accent = Color(0xFF10B981); // Green
  static const Color accent2 = Color(0xFFF59E0B); // Amber
  static const Color accent3 = Color(0xFFEF4444); // Red
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );
}

