import 'package:_247remotejobs/ui/views/profile/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EditProfileView extends StackedView<ProfileViewModel> {
  const EditProfileView({super.key});

  @override
  Widget builder(
      BuildContext context,
      ProfileViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: viewModel.nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: viewModel.emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) =>
                val == null || !val.contains("@") ? "Enter a valid email" : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: viewModel.isBusy ? null : viewModel.saveProfile,
                child: viewModel.isBusy
                    ? const CircularProgressIndicator()
                    : const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) =>
      ProfileViewModel();
}
