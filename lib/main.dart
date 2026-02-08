import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.dialogs.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'state.dart';
import 'core/utils/local_storage.dart';
import 'core/utils/local_store_dir.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  setupDialogUi();

  // Load persistence (Theme)
  final localStorage = locator<LocalStorage>();
  final savedMode = await localStorage.fetch(LocalStorageDir.uiMode);
  if (savedMode == "dark") {
    uiMode.value = AppUiModes.dark;
  } else {
    uiMode.value = AppUiModes.light;
  }

  WidgetsFlutterBinding.ensureInitialized();
  // Check if Firebase is already initialized
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Ignore duplicate initialization errors
    // print('Firebase already initialized: $e');
  }

  runApp(const NogesoftApp());
}

class NogesoftApp extends StatefulWidget {
  const NogesoftApp({super.key});

  @override
  State<NogesoftApp> createState() => _NogesoftAppState();
}

class _NogesoftAppState extends State<NogesoftApp> {
  @override
  void initState() {
    super.initState();
    uiMode.addListener(_onThemeChanged);
  }

  void _onThemeChanged() => setState(() {});

  @override
  void dispose() {
    uiMode.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nogesoft',
      debugShowCheckedModeBanner: false,

      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF2F4F7), // Light Gray
        cardColor: Colors.white,
        canvasColor: Colors.white, // For Drawer
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0F1B2D), // Dark Blue text/elements
          secondary: Color(0xFF38B24A), // Green accent
          surface: Colors.white,
          background: Color(0xFFF2F4F7),
          onBackground: Color(0xFF0B1220),
          onSurface: Color(0xFF0B1220),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF0B1220)),
          titleLarge: TextStyle(color: Color(0xFF0B1220)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Colors.black38),
          labelStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF38B24A), width: 1.5),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1220), // Deep Dark Blue
        cardColor: const Color(0xFF101A2B), // Dark Card
        canvasColor: const Color(0xFF0C1524), // Drawer Dark
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFF38B24A),
          surface: Color(0xFF101A2B),
          background: Color(0xFF0B1220),
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0C1524),
          hintStyle: const TextStyle(color: Colors.white38),
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF38B24A)),
          ),
        ),
      ),
      themeMode: uiMode.value == AppUiModes.dark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
