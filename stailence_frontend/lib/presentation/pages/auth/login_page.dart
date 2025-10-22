import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.loginTitle)),
      body: const Center(
        child: Text('Login Page'),
      ),
    );
  }
}
