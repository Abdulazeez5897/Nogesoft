import 'package:flutter/material.dart';

import 'core/data/models/user_model.dart';



enum AppUiModes { dark, light }
User user = user;

ValueNotifier<User> profile = ValueNotifier(User());
ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);
ValueNotifier<AppUiModes> uiMode = ValueNotifier(AppUiModes.light);
// ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);
