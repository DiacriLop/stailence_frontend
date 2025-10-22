import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../data/mock/negocios_mock.dart';
import '../../../domain/entities/negocio.dart';
import '../../../domain/entities/servicio.dart';
import '../negocios/negocio_detalle_page.dart';

class ServiciosPage extends StatelessWidget {
  const ServiciosPage({super.key});

  static const String routeName = '/servicios';

  @override
  Widget build(BuildContext context) {
    final List<Negocio> negocios = NegociosMock.build();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.serviciosTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explora negocios y sus servicios', style: AppTextStyles.headline.copyWith(fontSize: 22)),
            const SizedBox(height: 16),
            if (negocios.isNotEmpty)
              _FeaturedBusinessCard(
                negocio: negocios.first,
                onTap: () => _openBusinessDetail(context, negocios.first),
              ),
            const SizedBox(height: 24),
            Text('Categorías', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _categories
                  .map(
                    (category) => Chip(
                      label: Text(category),
                      backgroundColor: AppColors.elevatedSurface,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Text('Negocios populares', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            Column(
              children: List.generate(negocios.length, (int index) {
                final Negocio negocio = negocios[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index == negocios.length - 1 ? 0 : 16),
                  child: _BusinessCard(
                    negocio: negocio,
                    onTap: () => _openBusinessDetail(context, negocio),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _openBusinessDetail(BuildContext context, Negocio negocio) {
    Navigator.of(context).pushNamed(
      NegocioDetallePage.routeName,
      arguments: negocio,
    );
  }
}

const List<String> _categories = ['Cortes', 'Barbería', 'Tratamientos', 'Spa', 'Coloración', 'Maquillaje'];

class _FeaturedBusinessCard extends StatelessWidget {
  const _FeaturedBusinessCard({required this.negocio, required this.onTap});

  final Negocio negocio;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.promoGradientStart, AppColors.promoGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            negocio.nombre,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              negocio.horarioGeneral ?? 'Consulta los servicios destacados y reserva tu cita.',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: onTap,
              child: const Text('Ver negocio'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BusinessCard extends StatelessWidget {
  const _BusinessCard({required this.negocio, required this.onTap});

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
          color: AppColors.elevatedSurface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.16),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.store_mall_directory_outlined, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(negocio.nombre, style: AppTextStyles.subtitle.copyWith(fontSize: 18)),
                        if (negocio.direccion != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              negocio.direccion!,
                              style: AppTextStyles.body,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: AppColors.primary),
                ],
              ),
              if (negocio.serviciosDestacados != null && negocio.serviciosDestacados!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: negocio.serviciosDestacados!
                      .map<Widget>((Servicio servicio) => _ServiceChip(servicio: servicio))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.servicio});

  final Servicio servicio;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            servicio.nombre,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '${servicio.duracion} min · ${_formatCurrency(servicio.precio)}',
            style: AppTextStyles.body.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
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
