import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'themes/catppuccin_theme.dart';
import 'screens/dashboard_screen_simple.dart';
import 'providers/app_state_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ceguxofcukjhjizjlksw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNlZ3V4b2ZjdWtqaGppempsa3N3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1MjgwMTcsImV4cCI6MjA3MzEwNDAxN30.6k5gbEptJuisnvZ31UjI_KEXgijLSpROuE79KrSbt3I',
  );

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

// Get a reference your Supabase client
final supabase = Supabase.instance.client;
