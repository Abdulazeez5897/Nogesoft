
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../app/app.dialogs.dart';
import '../../app/app.locator.dart';
import '../../state.dart';
import '../../ui/views/dashboardViewModel.dart';
import '../data/repositories/repository.dart';
import '../utils/custom_pretty_dio_logger.dart';
import '../utils/dialog_utils.dart';
import '../utils/local_storage.dart';
import '../utils/local_store_dir.dart';
import 'api-responses.dart';
import 'api-service.dart';


/// @author Usman Abdulazeez
/// email: abdulazeezusman732@gmail.com
/// Aug, 2025
///


final nav = locator<NavigationService>();

final logInterceptor = CustomPrettyDioLogger(
  requestHeader: true,
  requestBody: true,
  responseBody: true,
  responseHeader: false,
  error: true,
  compact: true,
  maxWidth: 90,
);

int refreshTokenRetryCount = 0;
const int maxRetryCount = 3;
final repo = locator<Repository>();
final apiService = locator<ApiService>();
bool isDialogBeingDisplayed = false;

final requestInterceptors = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  },
  onResponse: (Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  },
  onError: (DioError dioError, ErrorInterceptorHandler handler) async {

    // Future<DialogResponse?> showDialog(String title, String? description) async {
    //   if (!isDialogBeingDisplayed) {
    //     isDialogBeingDisplayed = true;
    //      DialogResponse? res = await locator<DialogService>().showCustomDialog(
    //       variant: DialogType.infoAlert,
    //       title: title,
    //       description: description,
    //     );
    //     isDialogBeingDisplayed = false;
    //     return res;
    //   }
    //   return null;
    // }

    if (dioError.type == DioErrorType.connectTimeout) {
      await showDialog("Connection Timed Out", null, isDialogBeingDisplayed);
    }
    else if (dioError.type == DioErrorType.other) {
      await showDialog("Network is unreachable", null, isDialogBeingDisplayed);
    }
    else if (dioError.type == DioErrorType.receiveTimeout) {
      await showDialog("Receive Timed Out", null, isDialogBeingDisplayed);
      // stopLoadingOnTimeout(currentViewModel);
    }
    // else if (dioError.response?.statusCode == 401 && !dioError.requestOptions.path.startsWith('auth')) {
    else if (dioError.response?.statusCode == 401) {
      print('value of path is ${dioError.requestOptions.path}');
      if (refreshTokenRetryCount >= maxRetryCount) {
        // Reset counter and redirect user to login
        refreshTokenRetryCount = 0;
        ApiResponse res = await repo.logOut();
        // if (res.statusCode == 200) {
        //   locator<NavigationService>()
        //       .clearStackAndShow(Routes.authView, arguments:const AuthViewArguments(authType: AuthType.selection) );
        // }
      }
      refreshTokenRetryCount++;
      String? refreshToken = await locator<LocalStorage>().fetch(LocalStorageDir.authRefreshToken);

      if (refreshToken != null) {
        bool refreshTokenResult = await refreshAccessToken();

        if (refreshTokenResult) {
          refreshTokenRetryCount = 0;
          String newAccessToken = await locator<LocalStorage>().fetch(LocalStorageDir.authToken);
          final opts = Options(
            method: dioError.requestOptions.method,
            headers: {...dioError.requestOptions.headers,
              'Authorization': 'Bearer $newAccessToken',},
          );
          apiService.dio.request(
            dioError.requestOptions.path,
            options: opts,
            data: dioError.requestOptions.data,
            queryParameters: dioError.requestOptions.queryParameters,
          ).then(
                (r) => handler.resolve(r),
            onError: (e) => handler.reject(e),
          );
        } else {
          final res = await locator<DialogService>().showCustomDialog(
              variant: DialogType.infoAlert,
              title: "Session Expired",
              description: "Login again to continue");
          // if (res!.confirmed) {
          //   userLoggedIn.value = false;
          //   await locator<LocalStorage>().delete(LocalStorageDir.authToken);
          //   await locator<LocalStorage>().delete(LocalStorageDir.authUser);
          //   await locator<LocalStorage>().delete(LocalStorageDir.authRefreshToken);
          //   locator<NavigationService>()
          //       .clearStackAndShow(Routes.authView, arguments:const AuthViewArguments(authType: AuthType.selection) );
          // }
        }
      }
      else {
        if (kDebugMode) {
          print('refresh token is null');
        }
        final res = await showDialogWithResponse("Session Expired", "Login again to continue", isDialogBeingDisplayed);
        // if (res!.confirmed) {
        //   locator<NavigationService>()
        //       .clearStackAndShow(Routes.authView, arguments:const AuthViewArguments(authType: AuthType.selection) );
        // }

      }
    }
    else if(dioError.response?.statusCode == 401 && dioError.requestOptions.path.startsWith('/auth')){
      if (kDebugMode) {
        print('incorrect credentials');
      }
      if(dioError.response != null && dioError.response!.statusMessage != null){
        await showDialog(dioError.response!.statusMessage!, null, isDialogBeingDisplayed);
      }

    }
    else{
      handler.next(dioError);
    }

  },
);

Future<bool> refreshAccessToken() async {

  ApiResponse res = await repo.refresh({ "userId": profile.value.id,
    "Refresh-Token": await locator<LocalStorage>().fetch(LocalStorageDir.authRefreshToken)});
  if (res.statusCode == 200 && res.data['data']["accessToken"] != null) {
    String accessToken = res.data['data']["accessToken"];
    String refreshToken = res.data['data']["refreshToken"];
    await locator<LocalStorage>().save(LocalStorageDir.authToken, accessToken);
    await locator<LocalStorage>().save(LocalStorageDir.authRefreshToken, refreshToken);
    print('refresh successful');
    return true; // Refresh successful
  } else {
    print('refresh conditions aint true');
    print(res.data);
    return false; // Refresh failed
  }

}

void stopLoadingOnTimeout(BaseViewModel viewModel) {
  viewModel.setBusy(false);
  if (viewModel is DashboardViewModel) {
    viewModel.isCreateVisitLoading = false;
    viewModel.notifyListeners();
  }
}

