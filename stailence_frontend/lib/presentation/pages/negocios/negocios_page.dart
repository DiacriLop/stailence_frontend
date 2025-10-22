import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../domain/entities/negocio.dart';
import '../../widgets/empty_state.dart';
import 'negocio_detalle_page.dart';

class NegociosPage extends StatelessWidget {
  const NegociosPage({super.key, required this.negocios});

  static const String routeName = '/negocios';

  final List<Negocio> negocios;

  void _openDetail(BuildContext context, Negocio negocio) {
    Navigator.of(context).pushNamed(
      NegocioDetallePage.routeName,
      arguments: negocio,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.negociosTitle)),
      body: negocios.isEmpty
          ? const EmptyState(
              icon: Icons.store_mall_directory_outlined,
              title: 'No hay negocios disponibles',
              message: 'Pronto agregaremos salones y barberías para que puedas reservar.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              itemCount: negocios.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (BuildContext context, int index) {
                final Negocio negocio = negocios[index];
                return Hero(
                  tag: negocio.id,
                  child: _NegocioCard(
                    negocio: negocio,
                    onTap: () => _openDetail(context, negocio),
                  ),
                );
              },
            ),
    );
  }
}

class _NegocioCard extends StatelessWidget {
  const _NegocioCard({required this.negocio, required this.onTap});

  final Negocio negocio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (negocio.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    negocio.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          negocio.nombre,
                          style: AppTextStyles.subtitle.copyWith(fontSize: 20),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.16),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  if (negocio.direccion != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            negocio.direccion!,
                            style: AppTextStyles.body,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (negocio.telefono != null || negocio.correo != null) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        if (negocio.telefono != null)
                          _InfoChip(
                            icon: Icons.phone_outlined,
                            label: negocio.telefono!,
                          ),
                        if (negocio.correo != null)
                          _InfoChip(
                            icon: Icons.email_outlined,
                            label: negocio.correo!,
                          ),
                      ],
                    ),
                  ],
                  if (negocio.horarioGeneral != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              negocio.horarioGeneral!,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.elevatedSurface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
