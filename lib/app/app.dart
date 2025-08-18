
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/data/repositories/repository.dart';
import '../core/network/api-service.dart';
import '../core/utils/local_storage.dart';
import '../ui/dialogs/info_alert_dialog.dart';

import '../ui/views/authView.dart';
import '../ui/views/homeView.dart';
// @stacked-import
/// @author George David
/// email: georgequin19@gmail.com
/// Feb, 2024
///

@StackedApp(
  logger: StackedLogger(),
  routes: [
    MaterialRoute(page: HomeView),
    // MaterialRoute(page: StartupView),
    MaterialRoute(page: AuthView),
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
