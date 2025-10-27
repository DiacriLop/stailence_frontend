import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class TabAdmin extends StatelessWidget {
  const TabAdmin({super.key});

  static const String routeName = '/home/admin';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(AppStrings.adminTitle),
    );
  }
}
