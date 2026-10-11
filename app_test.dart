import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumi_planner/app.dart';
import 'package:lumi_planner/core/utils/date_utils.dart';
import 'package:lumi_planner/features/home/home_providers.dart';
import 'package:lumi_planner/features/home/task_model.dart';

void main() {
  group('tarih yardımcıları', () {
    test('selamlama saate göre değişir', () {
      expect(greetingFor(DateTime(2026, 10, 11, 8)), 'Günaydın');
      expect(greetingFor(DateTime(2026, 10, 11, 14)), 'İyi günler');
      expect(greetingFor(DateTime(2026, 10, 11, 20)), 'İyi akşamlar');
      expect(greetingFor(DateTime(2026, 10, 11, 2)), 'İyi geceler');
    });

    test('hafta pazartesi başlar', () {
      // 11 Ekim 2026 Pazar -> hafta 5 Ekim Pazartesi başlar
      expect(startOfWeek(DateTime(2026, 10, 11)), DateTime(2026, 10, 5));
      expect(startOfWeek(DateTime(2026, 10, 5)), DateTime(2026, 10, 5));
    });

    test('saat biçimi', () {
      expect(formatMinutes(9 * 60 + 5), '09:05');
    });
  });

  group('görev durumu', () {
    test('görev ekle, tamamla, geri aç', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final today = dateOnly(DateTime.now());
      c.read(tasksProvider.notifier).add(Task(
            id: '1',
            title: 'Deneme',
            date: today,
            category: TaskCategory.work,
          ));
      expect(c.read(weekStatsProvider).total, 1);
      expect(c.read(weekStatsProvider).ratio, 0);
      c.read(tasksProvider.notifier).toggle('1');
      expect(c.read(weekStatsProvider).ratio, 1);
      c.read(tasksProvider.notifier).toggle('1');
      expect(c.read(weekStatsProvider).ratio, 0);
    });

    test('görev yokken oran null (sahte yüzde yok)', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(c.read(weekStatsProvider).ratio, isNull);
    });
  });

  group('arayüz', () {
    testWidgets('ana sayfa boş durumu ve sekme geçişi', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: LumiApp()));
      await tester.pumpAndSettle();

      expect(find.text('Henüz görev yok'), findsOneWidget);
      expect(find.text('Haftalık İlerleme'), findsOneWidget);

      await tester.tap(find.text('Takvim').last);
      await tester.pumpAndSettle();
      expect(find.text('Takvim henüz hazır değil'), findsOneWidget);
    });
  });
}
