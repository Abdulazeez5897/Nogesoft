import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/app.dialogs.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'firebase_options.dart';
import 'state.dart'; // where your uiMode ValueNotifier is

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupDialogUi();
  // setupBottomSheetUi();


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


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

    // Listen for theme changes
    uiMode.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    // Rebuild only this State, MaterialApp widget identity stays the same
    setState(() {});
  }

  @override
  void dispose() {
    uiMode.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '247remotejobs',

      // ✅ keep your initial route
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [StackedService.routeObserver],

      // ✅ set up themes
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(),
      themeMode: uiMode.value == AppUiModes.dark
          ? ThemeMode.dark
          : ThemeMode.light,

      debugShowCheckedModeBanner: false,
    );
  }
}
