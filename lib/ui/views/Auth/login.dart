import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'auth_ViewModel.dart';




class Login extends StackedView<AuthViewModel> {
  const Login({super.key});

  @override
  Widget builder(
      BuildContext context,
      AuthViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Welcome to HomeView')),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => AuthViewModel();
}