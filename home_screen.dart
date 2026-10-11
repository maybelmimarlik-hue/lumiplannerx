import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/lumi_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/soft_card.dart';
import 'add_task_sheet.dart';
import 'home_providers.dart';
import 'progress_ring.dart';
import 'sky_header.dart';
import 'task_model.dart';

void _soon(BuildContext context, String what) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$what sonraki aşamalarda eklenecek.')));
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final greeting = greetingFor(DateTime.now());
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SkyHeader(height: 250 + topInset),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: 'Ara',
                            onPressed: () => _soon(context, 'Arama'),
                            icon: const Icon(Icons.search_rounded, color: LumiColors.navy),
                          ),
                          IconButton(
                            tooltip: 'Bildirimler',
                            onPressed: () => _soon(context, 'Bildirimler'),
                            icon: const Icon(Icons.notifications_none_rounded,
                                color: LumiColors.navy),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(greeting, style: t.displaySmall),
                      const SizedBox(height: 4),
                      Text('Bugün harika şeyler yapabilirsin.',
                          style: t.bodyMedium?.copyWith(color: LumiColors.navy.withOpacity(0.7))),
                    ],
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const _DateStrip(),
                    const SizedBox(height: 14),
                    LayoutBuilder(builder: (context, c) {
                      final wide = c.maxWidth >= 600;
                      const focus = _FocusCard();
                      final side = Column(
                        children: const [
                          _WeeklyProgressCard(),
                          SizedBox(height: 12),
                          _DayNoteCard(),
                        ],
                      );
                      if (wide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(flex: 5, child: focus),
                            const SizedBox(width: 12),
                            Expanded(flex: 4, child: side),
                          ],
                        );
                      }
                      return Column(children: [focus, const SizedBox(height: 12), side]);
                    }),
                    const SizedBox(height: 20),
                    const _QuickAccess(),
                    const SizedBox(height: 14),
                    const _NextTaskBar(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateStrip extends ConsumerWidget {
  const _DateStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final selected = ref.watch(selectedDateProvider);
    final today = dateOnly(DateTime.now());
    final start = startOfWeek(selected);

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Önceki hafta',
                  onPressed: () => ref.read(selectedDateProvider.notifier).state =
                      DateTime(selected.year, selected.month, selected.day - 7),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: Text(monthYearLabel(selected),
                      textAlign: TextAlign.center, style: t.titleMedium),
                ),
                if (!isSameDay(selected, today))
                  TextButton(
                    onPressed: () => ref.read(selectedDateProvider.notifier).state = today,
                    child: const Text('Bugün'),
                  ),
                IconButton(
                  tooltip: 'Sonraki hafta',
                  onPressed: () => ref.read(selectedDateProvider.notifier).state =
                      DateTime(selected.year, selected.month, selected.day + 7),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: _DayCell(
                    date: DateTime(start.year, start.month, start.day + i),
                    label: trWeekdayShort[i],
                    selected: isSameDay(DateTime(start.year, start.month, start.day + i), selected),
                    isToday: isSameDay(DateTime(start.year, start.month, start.day + i), today),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayCell extends ConsumerWidget {
  const _DayCell({
    required this.date,
    required this.label,
    required this.selected,
    required this.isToday,
  });

  final DateTime date;
  final String label;
  final bool selected;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      selected: selected,
      label: '${date.day} ${trMonths[date.month - 1]}${isToday ? ', bugün' : ''}',
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => ref.read(selectedDateProvider.notifier).state = date,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          constraints: const BoxConstraints(minHeight: 56),
          decoration: BoxDecoration(
            color: selected ? LumiColors.lavender : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: t.labelSmall?.copyWith(
                      color: selected ? Colors.white : LumiColors.gray)),
              const SizedBox(height: 4),
              Text('${date.day}',
                  style: t.titleMedium?.copyWith(
                      color: selected ? Colors.white : LumiColors.navy,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              // Bugünü yalnızca renkle değil, nokta ile de belirt
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isToday
                      ? (selected ? Colors.white : LumiColors.lavenderDark)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusCard extends ConsumerWidget {
  const _FocusCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final tasks = ref.watch(dayTasksProvider);

    return SoftCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Bugünün Odakları', style: t.titleMedium)),
              IconButton.filledTonal(
                tooltip: 'Görev ekle',
                onPressed: () => showAddTaskSheet(context),
                style: IconButton.styleFrom(
                  backgroundColor: LumiColors.lavenderLight,
                  foregroundColor: LumiColors.lavenderDark,
                ),
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Henüz görev yok', style: t.titleMedium),
                  const SizedBox(height: 4),
                  Text('Hayallerine bir adım daha yaklaşmak için ilk görevini ekle.',
                      style: t.bodySmall),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => showAddTaskSheet(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Yeni Görev Ekle'),
                  ),
                ],
              ),
            )
          else
            for (var i = 0; i < tasks.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: LumiColors.grayLine),
              _TaskRow(task: tasks[i]),
            ],
        ],
      ),
    );
  }
}

class _TaskRow extends ConsumerWidget {
  const _TaskRow({required this.task});
  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final c = task.category;
    final time = task.startMinutes == null
        ? 'Saat belirtilmedi'
        : task.endMinutes == null
            ? formatMinutes(task.startMinutes!)
            : '${formatMinutes(task.startMinutes!)} – ${formatMinutes(task.endMinutes!)}';

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: LumiColors.dangerLight,
        child: const Icon(Icons.delete_outline_rounded, color: LumiColors.danger),
      ),
      onDismissed: (_) {
        final removed = task;
        ref.read(tasksProvider.notifier).remove(removed.id);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('"${removed.title}" silindi'),
            action: SnackBarAction(
              label: 'Geri al',
              textColor: LumiColors.lavender,
              onPressed: () => ref.read(tasksProvider.notifier).add(removed),
            ),
          ));
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Row(
          children: [
            Checkbox(
              value: task.done,
              shape: const CircleBorder(),
              activeColor: LumiColors.lavenderDark,
              onChanged: (_) => ref.read(tasksProvider.notifier).toggle(task.id),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: c.background, shape: BoxShape.circle),
              child: Icon(c.icon, size: 20, color: c.color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: task.done ? TextDecoration.lineThrough : null,
                      color: task.done ? LumiColors.gray : LumiColors.navy,
                    ),
                  ),
                  Text('${c.label} · $time', style: t.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyProgressCard extends ConsumerWidget {
  const _WeeklyProgressCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final stats = ref.watch(weekStatsProvider);

    return SoftCard(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [LumiColors.skyLight, LumiColors.mintLight],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Haftalık İlerleme', style: t.titleMedium),
          const SizedBox(height: 12),
          Center(child: ProgressRing(ratio: stats.ratio)),
          const SizedBox(height: 12),
          if (stats.total == 0)
            Text('Bu hafta için görev eklendiğinde ilerlemen burada görünür.',
                style: t.bodySmall)
          else ...[
            Text('${stats.done}/${stats.total} görev tamamlandı', style: t.bodySmall),
            const SizedBox(height: 8),
            for (final e in stats.byCategory.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: e.key.color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.key.label, style: t.bodySmall)),
                    Text('${e.value.done}/${e.value.total}',
                        style: t.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _DayNoteCard extends ConsumerWidget {
  const _DayNoteCard();

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: ref.read(dayNoteProvider));
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bugünün Notu'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(hintText: 'Bugün için kısa bir not yaz…'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Kaydet')),
        ],
      ),
    );
    controller.dispose();
    if (result != null) ref.read(dayNoteProvider.notifier).state = result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final note = ref.watch(dayNoteProvider);

    return SoftCard(
      onTap: () => _edit(context, ref),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFF3D6), LumiColors.peachLight],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Bugünün Notu', style: t.titleMedium)),
              const Icon(Icons.edit_outlined, size: 18, color: LumiColors.gray),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.isEmpty ? 'Bugün için bir not eklemek üzere dokun.' : note,
            style: note.isEmpty ? t.bodySmall : t.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _QuickAccess extends StatelessWidget {
  const _QuickAccess();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final items = <({String label, IconData icon, Color bg, Color fg, VoidCallback onTap})>[
      (
        label: 'Toplantı Ekle',
        icon: Icons.event_outlined,
        bg: LumiColors.dangerLight,
        fg: LumiColors.danger,
        onTap: () => _soon(context, 'Etkinlik oluşturma'),
      ),
      (
        label: 'Not Ekle',
        icon: Icons.sticky_note_2_outlined,
        bg: LumiColors.skyLight,
        fg: const Color(0xFF3B82D6),
        onTap: () => _soon(context, 'Not oluşturma'),
      ),
      (
        label: 'Görev Ekle',
        icon: Icons.check_circle_outline_rounded,
        bg: LumiColors.peachLight,
        fg: const Color(0xFFE0713F),
        onTap: () => showAddTaskSheet(context),
      ),
      (
        label: 'Fotoğraf Ekle',
        icon: Icons.image_outlined,
        bg: LumiColors.mintLight,
        fg: const Color(0xFF2E9E78),
        onTap: () => _soon(context, 'Fotoğraf ekleme'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text('Hızlı Erişim', style: t.titleMedium),
        ),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth < 340 ? 2 : 4;
          const gap = 10.0;
          final w = (c.maxWidth - gap * (cols - 1)) / cols;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final i in items)
                SizedBox(
                  width: w,
                  child: Material(
                    color: i.bg,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: i.onTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                        child: Column(
                          children: [
                            Icon(i.icon, color: i.fg),
                            const SizedBox(height: 6),
                            Text(i.label,
                                textAlign: TextAlign.center,
                                style: t.labelSmall?.copyWith(color: LumiColors.navy)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

class _NextTaskBar extends ConsumerWidget {
  const _NextTaskBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final next = ref.watch(nextTaskProvider);

    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                color: LumiColors.lavenderLight, shape: BoxShape.circle),
            child: const Icon(Icons.alarm_rounded, color: LumiColors.lavenderDark, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sıradaki Görev', style: t.bodySmall),
                Text(
                  next?.title ?? 'Bugün için bekleyen görev yok',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (next?.startMinutes != null)
            Text(formatMinutes(next!.startMinutes!), style: t.bodySmall),
        ],
      ),
    );
  }
}
