import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/entities/negocio.dart';
import '../../../domain/entities/servicio.dart';
import '../../widgets/empty_state.dart';
import '../servicios/servicio_detalle_page.dart';

class NegocioDetallePage extends StatelessWidget {
  const NegocioDetallePage({super.key, required this.negocio});

  static const String routeName = '/negocios/detalle';

  final Negocio negocio;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.negocioDetalleTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.store_mall_directory_outlined, size: 32, color: AppColors.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(negocio.nombre, style: AppTextStyles.subtitle.copyWith(fontSize: 22)),
                            if (negocio.horarioGeneral != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 16, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        negocio.horarioGeneral!,
                                        style: AppTextStyles.body.copyWith(color: AppColors.primary),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (negocio.direccion != null) ...[
                    const SizedBox(height: 20),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Dirección',
                      value: negocio.direccion!,
                    ),
                  ],
                  if (negocio.telefono != null) ...[
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Teléfono',
                      value: negocio.telefono!,
                    ),
                  ],
                  if (negocio.correo != null) ...[
                    const SizedBox(height: 16),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Correo',
                      value: negocio.correo!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Servicios ofrecidos', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.elevatedSurface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: negocio.serviciosDestacados == null || negocio.serviciosDestacados!.isEmpty
                  ? const EmptyState(
                      icon: Icons.content_cut,
                      title: 'Sin servicios cargados',
                      message: 'Cuando registremos los servicios de este negocio los verás aquí.',
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(negocio.serviciosDestacados!.length, (index) {
                        final Servicio service = negocio.serviciosDestacados![index];
                        final bool isLast = index == negocio.serviciosDestacados!.length - 1;
                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => Navigator.of(context).pushNamed(
                            ServicioDetallePage.routeName,
                            arguments: service,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.16),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.content_cut, color: AppColors.primary, size: 18),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.nombre,
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${service.duracion} min',
                                        style: AppTextStyles.body,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  _formatCurrency(service.precio),
                                  style: AppTextStyles.subtitle.copyWith(color: AppColors.primary, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
            ),
            const SizedBox(height: 24),
            Text('Ubicación', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 180,
                color: theme.colorScheme.surfaceVariant,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.05)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.map_outlined, color: AppColors.primary, size: 40),
                          SizedBox(height: 8),
                          Text('Mapa no disponible', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

String _formatCurrency(double value) {
  final intValue = value.round();
  final String digits = intValue.toString();
  final String formatted = digits.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (Match match) => '${match[1]}.',
  );
  return 'COP $formatted';
}
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }
}
