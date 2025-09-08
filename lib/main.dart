import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'state.dart'; // where your uiMode ValueNotifier is

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      initialRoute: Routes.signUp,
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
