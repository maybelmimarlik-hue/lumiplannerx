import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/placeholder/module_placeholder.dart';
import '../features/shell/app_shell.dart';

GoRouter buildRouter() => GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => AppShell(navigationShell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/calendar',
                builder: (_, __) => const ModulePlaceholder(
                  title: 'Takvim',
                  icon: Icons.calendar_month_rounded,
                  phase: 'Aşama 4’te',
                ),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/notes',
                builder: (_, __) => const ModulePlaceholder(
                  title: 'Notlar',
                  icon: Icons.edit_note_rounded,
                  phase: 'Aşama 4’te',
                ),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/mail',
                builder: (_, __) => const ModulePlaceholder(
                  title: 'Mail',
                  icon: Icons.mail_rounded,
                  phase: 'Aşama 6’da',
                ),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/more',
                builder: (_, __) => const ModulePlaceholder(
                  title: 'Daha Fazla',
                  icon: Icons.more_horiz_rounded,
                  phase: 'sonraki aşamalarda',
                ),
              ),
            ]),
          ],
        ),
      ],
    );
