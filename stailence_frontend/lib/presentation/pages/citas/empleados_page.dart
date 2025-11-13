import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../data/repositories/empleado_servicio_repository.dart';
import '../../../domain/entities/servicio.dart';
import '../../../domain/entities/empleado_servicio.dart';
import '../../../domain/entities/empleado.dart';
import '../../../injection_container.dart';
import '../../widgets/empty_state.dart';

class EmpleadosPage extends StatelessWidget {
  const EmpleadosPage({super.key, required this.servicio});

  static const String routeName = '/empleados';

  final Servicio servicio;

  void _onTapEmpleado(BuildContext context, Empleado empleado) {
    Navigator.of(context).pushNamed(
      '/formulario-cita',
      arguments: {'servicio': servicio, 'empleado': empleado},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar profesional')),
      body: FutureBuilder<List<EmpleadoServicio>>(
        future: getIt<EmpleadoServicioRepository>().obtenerEmpleadosPorServicio(
          servicio.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            try {
              print('[EmpleadosPage] snapshot.hasError: ${snapshot.error}');
            } catch (_) {}
            return EmptyState(
              icon: Icons.error_outline,
              title: 'Error al cargar',
              message: 'No pudimos cargar los profesionales: ${snapshot.error}',
            );
          }

          final List<EmpleadoServicio> empleadosServicios =
              snapshot.data ?? <EmpleadoServicio>[];

          if (empleadosServicios.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'Sin profesionales',
              message: 'No hay profesionales disponibles para este servicio.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            itemCount: empleadosServicios.length,
            itemBuilder: (context, index) {
              final empleadoServicio = empleadosServicios[index];
              final empleado = empleadoServicio.empleado;

              return InkWell(
                onTap: () => _onTapEmpleado(context, empleado),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.elevatedSurface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.16),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${empleado.nombre} ${empleado.apellido}',
                              style: AppTextStyles.subtitle,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              empleado.correo,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
