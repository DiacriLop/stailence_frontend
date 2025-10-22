import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.registerTitle)),
      body: const Center(
        child: Text('Register Page'),
      ),
    );
  }
}
