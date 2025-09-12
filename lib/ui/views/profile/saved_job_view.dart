import 'package:_247remotejobs/ui/views/profile/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SavedJobsView extends StackedView<ProfileViewModel> {
  const SavedJobsView({super.key});

  @override
  Widget builder(
      BuildContext context,
      ProfileViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Jobs"),
        centerTitle: true,
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.savedJobs.isEmpty
          ? const Center(child: Text("No saved jobs"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.savedJobs.length,
        itemBuilder: (context, index) {
          final job = viewModel.savedJobs[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.bookmark, color: Colors.blue),
              title: Text(job['title'] ?? ""),
              subtitle: Text(job['company'] ?? ""),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => viewModel.removeJob(index),
              ),
            ),
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
    viewModel.loadSavedJobs();
    super.onViewModelReady(viewModel);
  }
}
