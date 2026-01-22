import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.dialogs.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'firebase_options.dart';
import 'state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator();
  setupDialogUi();

  WidgetsFlutterBinding.ensureInitialized();
  // Check if Firebase is already initialized
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Ignore duplicate initialization errors
    print('Firebase already initialized: $e');
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

      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: uiMode.value == AppUiModes.dark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
