import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'jobs_viewModel.dart';

class JobsView extends StackedView<JobsViewModel> {
  const JobsView({super.key});

  @override
  Widget builder(
      BuildContext context,
      JobsViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs')),
      body: const Center(
        child: Text('Jobs list goes here'),
      ),
    );
  }

  @override
  JobsViewModel viewModelBuilder(BuildContext context) =>
      JobsViewModel();
}
