import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class NotificacionesPage extends StatelessWidget {
  const NotificacionesPage({super.key});

  static const String routeName = '/notificaciones';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notificacionesTitle)),
      body: const Center(
        child: Text('Listado de notificaciones'),
      ),
    );
  }
}
