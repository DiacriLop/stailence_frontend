import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../servicios/servicios_page.dart';
import '../../../application/cita_provider.dart';
import '../../../domain/entities/cita.dart';
import 'cita_detalle_page.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  static const String routeName = '/citas';

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Load citas from provider
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CitaProvider>().cargarCitas();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CitaProvider citaProvider = context.watch<CitaProvider>();
    final bool isLoading = citaProvider.isLoading;
    final String? error = citaProvider.error;
    final List<Cita> citas = citaProvider.citas;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.citasTitle),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Próximas'),
              Tab(text: 'Completadas'),
              Tab(text: 'Canceladas'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(child: Text(error, style: AppTextStyles.body))
            : TabBarView(
                children: [
                  _CitasList(
                    citas: citas
                        .where((c) => c.estado.name == 'reservada')
                        .toList(),
                    emptyMessage: 'No tienes próximas citas.',
                  ),
                  _CitasList(
                    citas: citas
                        .where((c) => c.estado.name == 'completada')
                        .toList(),
                    emptyMessage: 'Aún no hay citas completadas.',
                  ),
                  _CitasList(
                    citas: citas
                        .where((c) => c.estado.name == 'cancelada')
                        .toList(),
                    emptyMessage: 'Aún no hay citas canceladas.',
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              Navigator.of(context).pushNamed(ServiciosPage.routeName),
          icon: const Icon(Icons.add),
          label: const Text('Reservar cita'),
        ),
      ),
    );
  }
}

class _CitasList extends StatelessWidget {
  const _CitasList({required this.citas, required this.emptyMessage});

  final List<Cita> citas;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (citas.isEmpty) {
      return Center(child: Text(emptyMessage, style: AppTextStyles.body));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
      itemCount: citas.length,
      itemBuilder: (context, index) {
        final c = citas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ListTile(
            title: Text(
              '${c.fechaEstimada.toLocal().toString().split(' ')[0]} · ${c.horaEstipulada}',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('Estado: ${c.estado.name}'),
            onTap: () {
              //Navigator.of(context).pushNamed(CitaDetallePage.routeName);
            },
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'detalles') {
                  //Navigator.of(context).pushNamed(CitaDetallePage.routeName);
                } else if (value == 'cancelar') {
                  // capture provider and messenger before awaiting to avoid using
                  // BuildContext across async gaps
                  final CitaProvider provider = context.read<CitaProvider>();
                  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(
                    context,
                  );
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirmar'),
                      content: const Text('¿Deseas cancelar esta cita?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Sí'),
                        ),
                      ],
                    ),
                  );
                  if (confirm != true) return;
                  try {
                    await provider.cancelarCita(c.id);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Cita cancelada')),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Error al cancelar: ${e.toString()}'),
                      ),
                    );
                  }
                }
              },
              itemBuilder: (_) => <PopupMenuEntry<String>>[
                const PopupMenuItem(value: 'detalles', child: Text('Detalles')),
                if (c.estado.name == 'reservada')
                  const PopupMenuItem(
                    value: 'cancelar',
                    child: Text('Cancelar'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
