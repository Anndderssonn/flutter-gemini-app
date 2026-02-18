import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gemini_app/config/config.dart';

Future<void> main() async {
  AppTheme.setSystemUiOverlayStyle(isDarkMode: true);
  await dotenv.load(fileName: '.env');
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
