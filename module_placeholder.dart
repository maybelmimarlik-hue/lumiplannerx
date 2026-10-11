import 'package:flutter/material.dart';
import '../../core/widgets/empty_state.dart';

/// Henüz geliştirilmemiş modüller için dürüst yer tutucu.
/// Özellik varmış gibi davranmaz; hangi aşamada geleceğini söyler.
class ModulePlaceholder extends StatelessWidget {
  const ModulePlaceholder({
    super.key,
    required this.title,
    required this.icon,
    required this.phase,
  });

  final String title;
  final IconData icon;
  final String phase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: EmptyState(
        icon: icon,
        title: '$title henüz hazır değil',
        message: 'Bu bölüm $phase geliştirilecek.',
      ),
    );
  }
}
