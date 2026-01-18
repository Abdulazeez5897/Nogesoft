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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B1220),
              Color(0xFF0F1B2D),
            ],
          ),
        ),
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
                    color: Colors.white,
                  ),
                ),

                verticalSpaceSmall,

                /// Tagline
                Text(
                  'Smartbiz.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
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
