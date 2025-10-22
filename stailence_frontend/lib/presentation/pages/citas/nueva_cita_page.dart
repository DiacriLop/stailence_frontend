import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class NuevaCitaPage extends StatelessWidget {
  const NuevaCitaPage({super.key});

  static const String routeName = '/citas/nueva';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.nuevaCitaTitle)),
      body: const Center(
        child: Text('Formulario para agendar una nueva cita'),
      ),
    );
  }
}
