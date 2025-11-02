import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/widgets/main_navigation.dart';
import 'app/modules/home/bindings/home_binding.dart';
import 'app/modules/history/bindings/history_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CalPal - Nutrition Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
      ),
      home: const MainNavigationWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationWrapper extends StatelessWidget {
  const MainNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize bindings
    HomeBinding().dependencies();
    HistoryBinding().dependencies();

    return const MainNavigationView();
  }
}
