import 'package:flutter/material.dart';

class TabClient extends StatelessWidget {
  const TabClient({super.key});

  static const String routeName = '/home/client';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Contenido para clientes'),
    );
  }
}
