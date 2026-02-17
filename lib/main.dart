import 'package:flutter/material.dart';
import 'package:flutter_gemini_app/config/config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  AppTheme.setSystemUiOverlayStyle(isDarkMode: true);
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme(isDarkMode: true).getTheme(),
    );
  }
}
