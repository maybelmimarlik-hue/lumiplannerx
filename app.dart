import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/app_config.dart';
import 'core/router.dart';
import 'core/theme/lumi_theme.dart';

class LumiApp extends StatefulWidget {
  const LumiApp({super.key});

  @override
  State<LumiApp> createState() => _LumiAppState();
}

class _LumiAppState extends State<LumiApp> {
  // Router yalnızca bir kez oluşturulur (yeniden çizimde sekme durumu kaybolmaz).
  final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: LumiTheme.light(),
      routerConfig: _router,
      locale: const Locale('tr', 'TR'),
      supportedLocales: const [Locale('tr', 'TR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
