import 'package:flutter/material.dart';

/// Referans tasarım panosundan çıkarılan merkezi renk sistemi.
class LumiColors {
  LumiColors._();

  // Ana vurgular
  static const lavender = Color(0xFFA78BFA);
  static const peach = Color(0xFFFF9F7A);
  static const sky = Color(0xFF7CC7FF);
  static const mint = Color(0xFF66CDAA);

  // Açık tonlar
  static const cream = Color(0xFFF8F4EE);
  static const lavenderLight = Color(0xFFEDE7FF);
  static const peachLight = Color(0xFFFFEBDF);
  static const skyLight = Color(0xFFE8F3FF);
  static const mintLight = Color(0xFFEBF7F0);

  // Metin ve nötrler
  static const navy = Color(0xFF1E2A44);
  static const navyDeep = Color(0xFF0F172A);
  // Referanstaki #94A3B8 küçük metinde düşük kontrastlı; okunabilirlik için koyulaştırıldı.
  static const gray = Color(0xFF64748B);
  static const grayLine = Color(0xFFE2E8F0);

  static const surface = Color(0xFFFFFFFF);
  static const danger = Color(0xFFE5566D);
  static const dangerLight = Color(0xFFFFE3E8);

  // Aktif sekme / vurgulu yazı için koyu lavanta
  static const lavenderDark = Color(0xFF6D4FE0);
}
