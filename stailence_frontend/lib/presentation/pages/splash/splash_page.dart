import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(AppStrings.appName),
      ),
    );
  }
}
