import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: DebtTrackerApp(),
    ),
  );
}

class DebtTrackerApp extends StatelessWidget {
  const DebtTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debt Tracker',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text('State Management Ready'),
        ),
      ),
    );
  }
}