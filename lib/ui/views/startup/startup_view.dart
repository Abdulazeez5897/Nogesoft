import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// App Name
                Text(
                  'Nogesoft',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary, // Adapts to Light/Dark
                  ),
                ),

                verticalSpaceSmall,

                /// Tagline
                Text(
                  'Business Operating System',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),

                verticalSpaceLarge,

                /// Optional loader (enable if needed)
                // const CircularProgressIndicator(
                //   valueColor: AlwaysStoppedAnimation(Colors.white),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) =>
      StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }
}
