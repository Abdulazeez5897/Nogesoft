import 'package:_247remotejobs/ui/views/Auth/login.dart';
import 'package:_247remotejobs/ui/views/Auth/register.dart';
import 'package:_247remotejobs/ui/views/Auth/signUp.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/data/repositories/repository.dart';
import '../core/network/api-service.dart';
import '../core/utils/local_storage.dart';
import '../ui/dialogs/info_alert_dialog.dart';

import '../ui/views/Auth/auth_View.dart';
import '../ui/views/Auth/authentication_service.dart';
import '../ui/views/homeView.dart';
// @stacked-import
/// @author Usman Abdulazeez
/// email: abdulazeezusman732@gmail.com
/// Aug, 2025
///

@StackedApp(
  logger: StackedLogger(),
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: AuthView),
    MaterialRoute(page: Login),
    MaterialRoute(page: Register),
    MaterialRoute(page: SignUp),
    // MaterialRoute(page: StartupView),
    // MaterialRoute(page: DashboardView),

    // MaterialRoute(page: NotificationView),
    // MaterialRoute(page: ProfileView),
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
  bottomsheets: [
    // StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
