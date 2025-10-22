import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class PagosPage extends StatelessWidget {
  const PagosPage({super.key});

  static const String routeName = '/pagos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.pagosTitle)),
      body: const Center(
        child: Text('Historial de pagos'),
      ),
    );
  }
}
