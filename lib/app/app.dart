import 'package:nogesoft/ui/views/dashboard/dashboard.dart';
import 'package:nogesoft/ui/views/store/store_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../core/data/repositories/repository.dart';
import '../core/network/api-service.dart';
import '../core/services/app_shell_service.dart';
import '../core/utils/local_storage.dart';
import '../ui/dialogs/info_alert_dialog.dart';
import '../core/data/repositories/i_repository.dart';
import '../core/data/repositories/in_memory_repository.dart';

import '../ui/views/home/home_view.dart';

import '../ui/views/auth/auth_view.dart';
import '../ui/views/auth/authentication_service.dart';
import '../ui/views/auth/login.dart';
import '../ui/views/auth/register.dart';
import '../ui/views/auth/sign_up.dart';

import '../ui/views/jobs/jobs_view.dart';
import '../ui/views/otp_verification/otp_verification.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/purchase/purchase_view.dart';
// @stacked-import

@StackedApp(
  logger: StackedLogger(),
  routes: [
    MaterialRoute(page: StartupView, initial: true),

    /// ✅ Main authenticated shell (wrapper)
    MaterialRoute(page: HomeView),

    /// Auth / onboarding
    MaterialRoute(page: SignUp),
    MaterialRoute(page: AuthView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: OtpVerificationView),
    MaterialRoute(page: RegistrationView),


    /// Other standalone pages (if you still need direct navigation)
    MaterialRoute(page: PurchaseView),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: JobsView),
    MaterialRoute(page: StoreView),
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

    /// Data Layer (InMemory for now)
    LazySingleton(classType: InMemoryRepository, asType: IRepository),
    LazySingleton(classType: AppShellService),
    // @stacked-service
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
