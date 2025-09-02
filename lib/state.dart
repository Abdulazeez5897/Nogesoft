import 'package:flutter/material.dart';

import 'core/data/models/user_model.dart';



enum AppUiModes { dark, light }
AppUser user = user;

ValueNotifier<AppUser> profile = ValueNotifier(AppUser());
ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);
ValueNotifier<AppUiModes> uiMode = ValueNotifier(AppUiModes.light);
ValueNotifier<bool> appLoading = ValueNotifier(false);
// ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);
