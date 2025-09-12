import 'package:_247remotejobs/ui/views/Auth/login.dart';
import 'package:_247remotejobs/ui/views/Auth/register.dart';
import 'package:_247remotejobs/ui/views/Auth/signUp.dart';
import 'package:_247remotejobs/ui/views/profile/application_view.dart';
import 'package:_247remotejobs/ui/views/profile/edit_profile_view.dart';
import 'package:_247remotejobs/ui/views/profile/profile_view.dart';
import 'package:_247remotejobs/ui/views/profile/saved_job_view.dart';
import 'package:_247remotejobs/ui/views/profile/settings_view.dart';
import 'package:_247remotejobs/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/data/repositories/repository.dart';
import '../core/network/api-service.dart';
import '../core/utils/local_storage.dart';
import '../ui/dialogs/info_alert_dialog.dart';

import '../ui/views/Auth/auth_View.dart';
import '../ui/views/Auth/authentication_service.dart';
import '../ui/views/Otp_Verification/otpVerification.dart';
import '../ui/views/home_view/home_view.dart';
// @stacked-import

@StackedApp(
  logger: StackedLogger(),
  routes: [
    MaterialRoute(page: StartupView, initial: true), // Set a clear initial route
    MaterialRoute(page: SignUp), // Set a clear initial route
    MaterialRoute(page: AuthView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: OtpVerificationView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: RegistrationView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ApplicationsView),
    MaterialRoute(page: SavedJobsView),
    MaterialRoute(page: EditProfileView),
    // Remove duplicate/conflicting routes
    // MaterialRoute(page: Register), // Remove if this is duplicate of SignUp
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: ApiService),
    LazySingleton(classType: LocalStorage),
    LazySingleton(classType: Repository),
    LazySingleton(classType: AuthenticationService),
    // @stacked-service
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}