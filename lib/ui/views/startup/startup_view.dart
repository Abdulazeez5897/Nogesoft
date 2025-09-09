import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({super.key});

  @override
  Widget builder(
      BuildContext context,
      StartupViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            // const FlutterLogo(size: 100),
            // verticalSpaceLarge,

            // App Name
            Text(
              '247 Remote Jobs',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: kcBlackColor,
              ),
            ),
            verticalSpaceSmall,

            // Tagline
            Text(
              'Find your dream remote job',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kcMediumGrey,
              ),
            ),
            verticalSpaceLarge,

            // Loading Indicator
            // if (viewModel.isBusy)
            //   const CircularProgressIndicator(
            //     valueColor: AlwaysStoppedAnimation(kcBlackColor),
            //   ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) {
    // Initialize the viewModel when it's ready
    viewModel.init(); // For ReactiveViewModel approach
    // No need to call anything for FutureViewModel approach
    super.onViewModelReady(viewModel);
  }
}