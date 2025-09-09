import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

class StartupViewModel extends ReactiveViewModel {
  final _navigationService = locator<NavigationService>();
  final _auth = FirebaseAuth.instance;

  @override
  List<ReactiveServiceMixin> get reactiveServices => [];

  void init() {
    runStartupLogic();
  }

  Future<void> runStartupLogic() async {
    setBusy(true);

    // Add a small delay to show the splash screen
    await Future.delayed(const Duration(seconds: 5));

    try {
      // Check authentication state
      final user = _auth.currentUser;

      if (user == null) {
        _navigationService.replaceWith(Routes.signUp);
      } else {
        final isProfileComplete = await _checkIfProfileComplete(user.uid);

        if (isProfileComplete) {
          _navigationService.replaceWith(Routes.homeView);
        } else {
          _navigationService.replaceWith(Routes.registrationView);
        }
      }
    } catch (e) {
      _navigationService.replaceWith(Routes.signUp);
    } finally {
      setBusy(false);
    }
  }

  Future<bool> _checkIfProfileComplete(String userId) async {
    return true;
  }
}