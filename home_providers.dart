import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/date_utils.dart';
import 'task_model.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => dateOnly(DateTime.now()));

class TasksNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => const [];

  void add(Task task) => state = [...state, task];

  void toggle(String id) => state = [
        for (final t in state) t.id == id ? t.copyWith(done: !t.done) : t,
      ];

  void remove(String id) => state = state.where((t) => t.id != id).toList();
}

final tasksProvider = NotifierProvider<TasksNotifier, List<Task>>(TasksNotifier.new);

/// "Bugünün Notu" - şimdilik bellekte, Aşama 3'te kalıcı hale gelecek.
final dayNoteProvider = StateProvider<String>((ref) => '');

/// Seçili günün görevleri, saate göre sıralı (saati olmayanlar sonda).
final dayTasksProvider = Provider<List<Task>>((ref) {
  final date = ref.watch(selectedDateProvider);
  final tasks = ref.watch(tasksProvider).where((t) => isSameDay(t.date, date)).toList();
  tasks.sort((a, b) => (a.startMinutes ?? 24 * 60).compareTo(b.startMinutes ?? 24 * 60));
  return tasks;
});

class WeekStats {
  const WeekStats(this.total, this.done, this.byCategory);
  final int total;
  final int done;
  final Map<TaskCategory, ({int total, int done})> byCategory;

  double? get ratio => total == 0 ? null : done / total;
}

/// Seçili günün haftasına ait gerçek istatistikler.
final weekStatsProvider = Provider<WeekStats>((ref) {
  final start = startOfWeek(ref.watch(selectedDateProvider));
  final end = DateTime(start.year, start.month, start.day + 7);
  final tasks = ref
      .watch(tasksProvider)
      .where((t) => !t.date.isBefore(start) && t.date.isBefore(end))
      .toList();
  final map = <TaskCategory, ({int total, int done})>{};
  for (final t in tasks) {
    final cur = map[t.category] ?? (total: 0, done: 0);
    map[t.category] = (total: cur.total + 1, done: cur.done + (t.done ? 1 : 0));
  }
  return WeekStats(tasks.length, tasks.where((t) => t.done).length, map);
});

/// Bugün için sıradaki tamamlanmamış görev.
final nextTaskProvider = Provider<Task?>((ref) {
  final today = dateOnly(DateTime.now());
  final now = DateTime.now();
  final nowMin = now.hour * 60 + now.minute;
  final pending = ref
      .watch(tasksProvider)
      .where((t) => isSameDay(t.date, today) && !t.done)
      .toList()
    ..sort((a, b) => (a.startMinutes ?? 24 * 60).compareTo(b.startMinutes ?? 24 * 60));
  if (pending.isEmpty) return null;
  final upcoming = pending.where((t) => (t.startMinutes ?? 0) >= nowMin);
  return upcoming.isNotEmpty ? upcoming.first : pending.first;
});
