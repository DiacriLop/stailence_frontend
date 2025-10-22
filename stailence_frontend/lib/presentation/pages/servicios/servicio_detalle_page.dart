import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/app_state.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/servicio.dart';
import '../../../domain/entities/usuario.dart';
import '../../widgets/empty_state.dart';
import '../citas/nueva_cita_page.dart';

class ServicioDetallePage extends StatefulWidget {
  const ServicioDetallePage({super.key, this.servicio});

  static const String routeName = '/servicios/detalle';

  final Servicio? servicio;

  @override
  State<ServicioDetallePage> createState() => _ServicioDetallePageState();
}

class _ServicioDetallePageState extends State<ServicioDetallePage> {
  Servicio? _servicio;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _servicio ??= widget.servicio ?? ModalRoute.of(context)?.settings.arguments as Servicio?;
  }

  @override
  Widget build(BuildContext context) {
    final Servicio? servicio = _servicio;
    if (servicio == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Servicio')),
        body: const Center(child: Text('No se encontró información del servicio.')),
      );
    }

    final AppState appState = context.watch<AppState>();
    final List<Usuario> profesionales = appState.empleadosParaServicio(servicio.id);

    return Scaffold(
      appBar: AppBar(title: Text(servicio.nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ServiceHeader(servicio: servicio),
            const SizedBox(height: 24),
            Text('Profesionales disponibles', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            if (profesionales.isEmpty)
              const EmptyState(
                icon: Icons.people_outline,
                title: 'Sin profesionales',
                message: 'Cuando asignemos especialistas para este servicio los verás aquí.',
              )
            else
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: profesionales
                    .map(
                      (Usuario profesional) => _ProfessionalCard(
                        servicio: servicio,
                        profesional: profesional,
                        onReservar: () => _openBooking(context, servicio, profesional),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
  void _openBooking(BuildContext context, Servicio servicio, Usuario profesional) {
    Navigator.of(context).pushNamed(
      NuevaCitaPage.routeName,
      arguments: NuevaCitaPageArguments(servicio: servicio, profesional: profesional),
    );
  }
}

class _ServiceHeader extends StatelessWidget {
  const _ServiceHeader({required this.servicio});

  final Servicio servicio;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(servicio.nombre, style: AppTextStyles.headline.copyWith(fontSize: 24)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text('Duración: ${servicio.duracion} minutos', style: AppTextStyles.body),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.monetization_on_outlined, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(Formatters.formatCurrency(servicio.precio), style: AppTextStyles.body),
            ],
          ),
          if (servicio.categoria != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category_outlined, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Categoría: ${servicio.categoria}', style: AppTextStyles.body),
              ],
            ),
          ],
          ],
      ),
    );
  }
}

class _ProfessionalCard extends StatelessWidget {
  const _ProfessionalCard({
    required this.servicio,
    required this.profesional,
    required this.onReservar,
  });

  final Servicio servicio;
  final Usuario profesional;
  final VoidCallback onReservar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: Text(
              _initials(profesional),
              style: AppTextStyles.subtitle.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${profesional.nombre} ${profesional.apellido}',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            'Especialista en ${servicio.categoria ?? 'servicios'}',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onReservar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Reservar'),
            ),
          ),
        ],
      ),
    );
  }

  String _initials(Usuario usuario) {
    final String first = usuario.nombre.isNotEmpty ? usuario.nombre[0] : '';
    final String last = usuario.apellido.isNotEmpty ? usuario.apellido[0] : '';
    return (first + last).toUpperCase();
  }
}
