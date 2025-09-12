import 'package:_247remotejobs/ui/views/profile/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ApplicationsView extends StackedView<ProfileViewModel> {
  const ApplicationsView({super.key});

  @override
  Widget builder(
      BuildContext context,
      ProfileViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Application History"),
        centerTitle: true,
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.applications.isEmpty
          ? const Center(child: Text("No applications found"))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.applications.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final app = viewModel.applications[index];
          return ListTile(
            leading: const Icon(Icons.work_outline),
            title: Text(app['title']!),
            subtitle: Text("Status: ${app['status']}"),
            trailing: Text(app['date']!),
          );
        },
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) =>
      ProfileViewModel();

  @override
  void onViewModelReady(ProfileViewModel viewModel) {
    viewModel.loadApplications();
    super.onViewModelReady(viewModel);
  }
}
