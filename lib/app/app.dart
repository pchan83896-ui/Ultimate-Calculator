import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class UltimateCalculatorApp extends StatelessWidget {
  const UltimateCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultimate Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.calculator,
      routes: {
        AppRoutes.calculator: (_) => const _PlaceholderPage(
              title: 'Calculator',
            ),
        AppRoutes.history: (_) => const _PlaceholderPage(
              title: 'History',
            ),
        AppRoutes.favorites: (_) => const _PlaceholderPage(
              title: 'Favorites',
            ),
        AppRoutes.settings: (_) => const _PlaceholderPage(
              title: 'Settings',
            ),
        AppRoutes.premium: (_) => const _PlaceholderPage(
              title: 'Premium',
            ),
      },
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(title),
      ),
    );
  }
}
