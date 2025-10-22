import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class TabEmpleado extends StatelessWidget {
  const TabEmpleado({super.key});

  static const String routeName = '/home/employee';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(AppStrings.empleadoTitle),
    );
  }
}
