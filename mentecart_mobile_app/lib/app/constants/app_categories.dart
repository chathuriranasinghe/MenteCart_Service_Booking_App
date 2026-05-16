import 'package:flutter/material.dart';

class AppCategory {
  const AppCategory({required this.title, required this.icon, required this.color});
  final String title;
  final IconData icon;
  final Color color;
}

const List<AppCategory> appCategories = [
  AppCategory(title: 'Cleaning', icon: Icons.cleaning_services_rounded, color: Color(0xFFEFF3FF)),
  AppCategory(title: 'Plumbing', icon: Icons.plumbing_rounded, color: Color(0xFFEAF8FF)),
  AppCategory(title: 'Tutoring', icon: Icons.menu_book_rounded, color: Color(0xFFEFFBF1)),
  AppCategory(title: 'Beauty', icon: Icons.spa_rounded, color: Color(0xFFFFEFF5)),
  AppCategory(title: 'Electrical', icon: Icons.electrical_services_rounded, color: Color(0xFFFFFBEA)),
  AppCategory(title: 'Carpentry', icon: Icons.handyman_rounded, color: Color(0xFFFFF3E0)),
  AppCategory(title: 'Painting', icon: Icons.format_paint_rounded, color: Color(0xFFF3E5F5)),
  AppCategory(title: 'Gardening', icon: Icons.yard_rounded, color: Color(0xFFE8F5E9)),
];
