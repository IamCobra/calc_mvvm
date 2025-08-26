import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'design/app_design.dart';
import 'views/modern_menu_view.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: AppDesign.accentColor,
          secondary: AppDesign.successColor,
          surface: AppDesign.surfaceColor,
          error: AppDesign.errorColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppDesign.backgroundColor,
        fontFamily: 'SF Pro Display', // ios fallback hvis det skulle være
      ),
      home: const ModernMenuView(),
      debugShowCheckedModeBanner: false,
      // Tillad rotation og behold staten til at stadig virke
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
