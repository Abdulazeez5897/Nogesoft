// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';
//
// import 'core/data/models/user_model.dart';
//
 import 'package:flutter/cupertino.dart';

enum AppUiModes { dark, light }
//
//
// ValueNotifier<User> profile = ValueNotifier(User());
// ValueNotifier<bool> userLoggedIn = ValueNotifier(false);
// ValueNotifier<bool> isFirstLaunch = ValueNotifier(true);
 ValueNotifier<AppUiModes> uiMode = ValueNotifier(AppUiModes.light);
// ValueNotifier<bool> refreshUpdatesNotifier = ValueNotifier(false);
//
// bool get isUserVerified =>
//     profile.value.approvalStatus == ApprovalStatus.APPROVED &&
//         !(profile.value.roles ?? []).any((r) => r.name?.toUpperCase() == 'ESTATE_MANAGER');
//
//  bool get isUserEstateManager =>
//     profile.value.roles?.any((r) => r.name?.toUpperCase() == 'ESTATE_MANAGER') ?? false;
