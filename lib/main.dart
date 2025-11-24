import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'data/models/debt_model.dart';
import 'data/models/transaction_model.dart';
import 'data/models/person_model.dart';
import 'presentation/providers/debt_provider.dart';
import 'navigation/main_navigation.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  Hive.registerAdapter(DebtModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(PersonModelAdapter());
  Hive.registerAdapter(DebtTypeAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  
  await Hive.openBox<DebtModel>('debts');
  await Hive.openBox<TransactionModel>('transactions');
  await Hive.openBox<PersonModel>('persons');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DebtProvider()),
      ],
      child: MaterialApp(
        title: 'Debt Tracker',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const MainNavigation(),
      ),
    );
  }
}