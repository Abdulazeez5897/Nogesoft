import 'package:flutter/material.dart';

import 'core/data/models/user_model.dart';



enum AppUiModes { dark, light }
User user = user;

ValueNotifier<User> profile = ValueNotifier(User(id: '', firstName: '', lastName: '', email: '', professionalHeadline: '', location: '', skills: [], experience: [], education: []));
ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);
ValueNotifier<AppUiModes> uiMode = ValueNotifier(AppUiModes.light);
ValueNotifier<bool> appLoading = ValueNotifier(false);
// ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);
