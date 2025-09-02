import 'package:_247remotejobs/state.dart';
import 'package:_247remotejobs/ui/common/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/app.dialogs.dart';
import 'app/app.locator.dart';
import 'app/app.router.dart';
import 'core/data/models/user_model.dart' hide user;
import 'core/utils/local_storage.dart';
import 'core/utils/local_store_dir.dart';
import 'firebase_options.dart';

/// @author Usman Abdulazeez
/// email: abdulazeezusman732@gmail.com
/// Aug, 2025
///

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  setupDialogUi();
  // setupBottomSheetUi();


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    fetchUiState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // checkForUpdates();
    });    // handleDeepLinks();
  }

  // void handleDeepLinks() async {
  //   // Listen for deep links
  //   uriLinkStream.listen((Uri? uri) {
  //     if (uri != null) {
  //       print("Deep Link Received: ${uri.toString()}");
  //       // Handle navigation in the app
  //     }
  //   });
  // }
  void fetchUiState() async {
    String? savedMode =
    await locator<LocalStorage>().fetch(LocalStorageDir.uiMode);
    if (savedMode != null) {
      switch (savedMode) {
        case "light":
          uiMode.value = AppUiModes.light;
          break;
        case "dark":
          uiMode.value = AppUiModes.dark;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        bool isAuthenticated = snapshot.hasData && snapshot.data != null;

        return ValueListenableBuilder<AppUiModes>(
          valueListenable: uiMode,
          builder: (context, value, child) => MaterialApp(
            title: '247remotejobs',
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(),
            themeMode: value == AppUiModes.dark ? ThemeMode.dark : ThemeMode.light,
            initialRoute: Routes.signUp,
            onGenerateRoute: StackedRouter().onGenerateRoute,
            navigatorKey: StackedService.navigatorKey,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              StackedService.routeObserver,
            ],
          ),
        );
      },
    );
  }


  ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kcWhiteColor,
        ),
        iconTheme: const IconThemeData(color: kcWhiteColor),
        toolbarTextStyle: const TextStyle(color: kcWhiteColor),
        elevation: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      brightness: Brightness.dark,
      primaryColor: kcBackgroundColor,
      focusColor: kcPrimaryColor,
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: kcWhiteColor),
    );
  }

  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kcBlackColor,
        ),
        iconTheme: const IconThemeData(color: kcBlackColor),
        toolbarTextStyle: const TextStyle(color: kcBlackColor),
        backgroundColor: kcWhiteColor,
        elevation: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      primaryColor: kcBackgroundColor,
      focusColor: kcPrimaryColor,
      textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: kcBlackColor),
    );
  }

  // void checkForUpdates() async {
  //   final availability = await getUpdateAvailability();
  //   if (availability is UpdateAvailable) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       showUpdateCard();
  //     });
  //   }
  // }

  // void showUpdateCard() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: Card(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               SvgPicture.asset(
  //                 'assets/icons/update.svg',
  //                 height: 10,
  //               ),
  //               const ListTile(
  //                 title: Text('App Updates', style: TextStyle(fontSize: 12,
  //                   fontFamily: "Panchang", fontWeight: FontWeight.bold,)),
  //                 subtitle: Text('A new version of Easyph is now available.'
  //                     ' download now to enjoy our lastest features.', style: TextStyle(fontSize: 8,
  //                   fontFamily: "Panchang",)),
  //               ),
  //               ButtonBar(
  //                 children: <Widget>[
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context); // Close the dialog
  //                       // Add logic to navigate to the store or perform the update
  //                     },
  //                     child: const Text('Update Now'),
  //                   ),
  //                   // TextButton(
  //                   //   onPressed: () {
  //                   //     Navigator.pop(context); // Close the dialog
  //                   //   },
  //                   //   child: Text('Later'),
  //                   // ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
