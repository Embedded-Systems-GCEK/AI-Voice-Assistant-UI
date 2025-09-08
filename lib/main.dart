import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/catppuccin_theme.dart';
import 'screens/dashboard_screen.dart';
import 'providers/app_state_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateProvider(),
      child: MaterialApp(
        title: 'AI Voice Assistant',
        theme: CatppuccinTheme.darkTheme,
        home: const DashboardScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
