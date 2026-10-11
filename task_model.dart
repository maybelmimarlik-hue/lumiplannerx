import 'package:flutter/material.dart';
import '../../core/theme/lumi_colors.dart';

enum TaskCategory {
  work('İş', Icons.laptop_mac_rounded, LumiColors.danger, LumiColors.dangerLight),
  sport('Spor', Icons.fitness_center_rounded, Color(0xFF3B82D6), LumiColors.skyLight),
  personal('Kişisel', Icons.person_outline_rounded, Color(0xFFE0713F), LumiColors.peachLight),
  reading('Okuma', Icons.menu_book_rounded, Color(0xFF2E9E78), LumiColors.mintLight),
  other('Diğer', Icons.bookmark_border_rounded, LumiColors.lavenderDark, LumiColors.lavenderLight);

  const TaskCategory(this.label, this.icon, this.color, this.background);
  final String label;
  final IconData icon;
  final Color color;
  final Color background;
}

/// Aşama 1–2: bellek içi model. Aşama 3'te Drift tablosuna taşınacak.
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    this.startMinutes,
    this.endMinutes,
    this.done = false,
  });

  final String id;
  final String title;
  final DateTime date; // yalnızca tarih kısmı
  final TaskCategory category;
  final int? startMinutes;
  final int? endMinutes;
  final bool done;

  Task copyWith({bool? done}) => Task(
        id: id,
        title: title,
        date: date,
        category: category,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        done: done ?? this.done,
      );
}
