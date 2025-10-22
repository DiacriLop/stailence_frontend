import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class ServicioDetallePage extends StatelessWidget {
  const ServicioDetallePage({super.key});

  static const String routeName = '/servicios/detalle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.servicioDetalleTitle)),
      body: const Center(
        child: Text('Información del servicio seleccionado'),
      ),
    );
  }
}
