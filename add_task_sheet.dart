import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/lumi_colors.dart';
import '../../core/utils/date_utils.dart';
import 'home_providers.dart';
import 'task_model.dart';

Future<void> showAddTaskSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: LumiColors.cream,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => const _AddTaskSheet(),
  );
}

class _AddTaskSheet extends ConsumerStatefulWidget {
  const _AddTaskSheet();

  @override
  ConsumerState<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<_AddTaskSheet> {
  final _title = TextEditingController();
  TaskCategory _category = TaskCategory.personal;
  TimeOfDay? _start;
  TimeOfDay? _end;
  String? _titleError;
  String? _timeError;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pick(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _start : _end) ?? TimeOfDay.now(),
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
      _timeError = null;
    });
  }

  void _save() {
    final title = _title.text.trim();
    String? titleError;
    String? timeError;
    if (title.isEmpty) titleError = 'Lütfen bir görev adı girin.';
    if (_end != null && _start == null) {
      timeError = 'Bitiş saati için önce başlangıç saatini seçin.';
    } else if (_start != null && _end != null && minutesOf(_end!) <= minutesOf(_start!)) {
      timeError = 'Bitiş saati başlangıçtan sonra olmalı.';
    }
    if (titleError != null || timeError != null) {
      setState(() {
        _titleError = titleError;
        _timeError = timeError;
      });
      return;
    }
    ref.read(tasksProvider.notifier).add(Task(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          date: ref.read(selectedDateProvider),
          category: _category,
          startMinutes: _start == null ? null : minutesOf(_start!),
          endMinutes: _end == null ? null : minutesOf(_end!),
        ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final date = ref.watch(selectedDateProvider);
    return Padding(
      // Klavye açıldığında form görünür kalsın
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Yeni görev', style: t.titleLarge),
            const SizedBox(height: 4),
            Text('${date.day} ${trMonths[date.month - 1]} ${date.year}', style: t.bodySmall),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Görev adı',
                errorText: _titleError,
              ),
              onChanged: (_) {
                if (_titleError != null) setState(() => _titleError = null);
              },
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 16),
            Text('Kategori', style: t.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in TaskCategory.values)
                  ChoiceChip(
                    label: Text(c.label),
                    avatar: Icon(c.icon, size: 16, color: c.color),
                    selected: _category == c,
                    onSelected: (_) => setState(() => _category = c),
                    selectedColor: c.background,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: _category == c ? c.color : LumiColors.grayLine),
                    shape: const StadiumBorder(),
                    showCheckmark: false,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(true),
                    icon: const Icon(Icons.schedule_rounded, size: 18),
                    label: Text(_start == null ? 'Başlangıç' : formatMinutes(minutesOf(_start!))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(false),
                    icon: const Icon(Icons.schedule_rounded, size: 18),
                    label: Text(_end == null ? 'Bitiş' : formatMinutes(minutesOf(_end!))),
                  ),
                ),
              ],
            ),
            if (_timeError != null) ...[
              const SizedBox(height: 8),
              Text(_timeError!, style: t.bodySmall?.copyWith(color: LumiColors.danger)),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _save, child: const Text('Kaydet')),
            ),
          ],
        ),
      ),
    );
  }
}
