import 'package:flutter/material.dart';
import '../../../data/models/cita_model.dart';
import 'citas_page.dart';
import '../../../core/constants/text_styles.dart';

class ConfirmacionCitaPage extends StatelessWidget {
  const ConfirmacionCitaPage({super.key, required this.cita});

  static const String routeName = '/citas/confirmacion';

  final CitaModel cita;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cita Confirmada')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text('¡Cita Agendada!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 30),
            _buildInfoRow('Fecha:', cita.fechaEstimada.toLocal().toString().split(' ')[0]),
            _buildInfoRow('Hora:', cita.horaEstipulada),
            _buildInfoRow('Estado:', cita.estado.name),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Citas page and clear navigation stack
                Navigator.of(context).pushNamedAndRemoveUntil(CitasPage.routeName, (route) => false);
              },
              child: const Text('Ver mis citas'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
