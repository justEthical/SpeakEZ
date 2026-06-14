import 'package:flutter/material.dart';
import 'package:speak_ez/Constants/app_data.dart';

/// Per-category icon + gradient used by the practice cards and the
/// scenarios-list header. The first six entries match the Fluent Flow design.
class CategoryStyle {
  final IconData icon;
  final List<Color> gradient;
  const CategoryStyle(this.icon, this.gradient);
}

const List<CategoryStyle> kCategoryStyles = [
  CategoryStyle(Icons.home_rounded, [Color(0xFF6366F1), Color(0xFF4338CA)]),
  CategoryStyle(
    Icons.family_restroom_rounded,
    [Color(0xFFEC4899), Color(0xFFBE185D)],
  ),
  CategoryStyle(Icons.restaurant_rounded, [Color(0xFF06B6D4), Color(0xFF0891B2)]),
  CategoryStyle(Icons.school_rounded, [Color(0xFF10B981), Color(0xFF047857)]),
  CategoryStyle(Icons.work_rounded, [Color(0xFFF59E0B), Color(0xFFB45309)]),
  CategoryStyle(
    Icons.shopping_cart_rounded,
    [Color(0xFF0F172A), Color(0xFF334155)],
  ),
  CategoryStyle(Icons.forum_rounded, [Color(0xFF8B5CF6), Color(0xFF6D28D9)]),
  CategoryStyle(Icons.devices_rounded, [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
  CategoryStyle(Icons.public_rounded, [Color(0xFF14B8A6), Color(0xFF0F766E)]),
  CategoryStyle(Icons.lightbulb_rounded, [Color(0xFFF43F5E), Color(0xFFBE123C)]),
];

CategoryStyle categoryStyleAt(int index) =>
    kCategoryStyles[index % kCategoryStyles.length];

/// Resolves a category's style by its title (falls back to the first style).
CategoryStyle categoryStyleForTitle(String title) {
  final i =
      AppData.scenarioCategories.indexWhere((c) => c.title == title);
  return categoryStyleAt(i < 0 ? 0 : i);
}
