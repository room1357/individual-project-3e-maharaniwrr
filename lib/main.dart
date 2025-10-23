import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/expense_screen.dart';
import 'models/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Praktik Bab 6',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return HomeScreen(user: user);
        },
        '/favorite': (context) => const FavoritePage(),
        '/profile': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return ProfileScreen(user: user);
        },
        '/setting': (context) => const SettingsScreen(),
        '/expense': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as User;
          return ExpenseScreen(user: user);
        },
      },
    );
  }
}