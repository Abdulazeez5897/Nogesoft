

import 'package:stacked_services/stacked_services.dart';

import '../../app/app.dialogs.dart';
import '../../app/app.locator.dart';


Future<DialogResponse?> showDialogWithResponse(String title, String? description, bool isDialogBeingDisplayed) async {
  if (!isDialogBeingDisplayed) {
    isDialogBeingDisplayed = true;
    DialogResponse? res = await locator<DialogService>().showCustomDialog(
      variant: DialogType.infoAlert,
      title: title,
      description: description,
    );
    isDialogBeingDisplayed = false;
    return res;
  }
  return null;
}

Future<bool?> showDialog(String title, String? description, bool isDialogBeingDisplayed) async {
  if (!isDialogBeingDisplayed) {
    isDialogBeingDisplayed = true;
    locator<SnackbarService>().showSnackbar(title: title,message: description ?? '' , duration: Duration(seconds: 1));
    isDialogBeingDisplayed = false;
    return isDialogBeingDisplayed;
  }
  return null;
}