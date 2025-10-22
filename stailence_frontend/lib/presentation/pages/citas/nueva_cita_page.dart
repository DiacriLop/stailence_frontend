import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/app_state.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/cita.dart';
import '../../../domain/entities/disponibilidad.dart';
import '../../../domain/entities/servicio.dart';
import '../../../domain/entities/usuario.dart';

class NuevaCitaPageArguments {
  const NuevaCitaPageArguments({required this.servicio, required this.profesional});

  final Servicio servicio;
  final Usuario profesional;
}

class NuevaCitaPage extends StatefulWidget {
  const NuevaCitaPage({super.key, required this.arguments});

  static const String routeName = '/citas/nueva';

  final NuevaCitaPageArguments arguments;

  @override
  State<NuevaCitaPage> createState() => _NuevaCitaPageState();
}

class _NuevaCitaPageState extends State<NuevaCitaPage> {
  Servicio? _servicio;
  Usuario? _profesional;
  DateTime? _selectedDate;
  String? _selectedHour;
  List<String> _availableHours = <String>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_servicio != null && _profesional != null) {
      return;
    }
    final NuevaCitaPageArguments args = widget.arguments;
    _servicio = args.servicio;
    _profesional = args.profesional;

    final AppState appState = Provider.of<AppState>(context, listen: false);
    final List<Disponibilidad> disponibilidad =
        appState.disponibilidadEmpleado(_profesional!.id);
    if (disponibilidad.isEmpty) {
      return;
    }
    final DateTime? initialDate = _firstAvailableDate(disponibilidad);
    if (initialDate != null) {
      _selectedDate = initialDate;
      _availableHours = _buildAvailableHours(disponibilidad, initialDate);
      _selectedHour = _availableHours.isEmpty ? null : _availableHours.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Servicio? servicio = _servicio;
    final Usuario? profesional = _profesional;
    if (servicio == null || profesional == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.nuevaCitaTitle)),
        body: const Center(child: Text('No se pudo cargar la información de la cita.')),
      );
    }

    final AppState appState = context.watch<AppState>();
    final List<Disponibilidad> disponibilidad = appState.disponibilidadEmpleado(profesional.id);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.nuevaCitaTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ServiceSummaryCard(servicio: servicio),
            const SizedBox(height: 20),
            _ProfessionalSummaryCard(profesional: profesional),
            const SizedBox(height: 28),
            Text('Seleccionar día', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            if (disponibilidad.isEmpty)
              const _EmptyStateCard(
                icon: Icons.calendar_month_outlined,
                message: 'Este profesional aún no tiene disponibilidad registrada.',
              )
            else
              _DayPicker(
                availability: disponibilidad,
                selectedDate: _selectedDate,
                onDateSelected: (DateTime date) {
                  setState(() {
                    _selectedDate = date;
                    _availableHours = _buildAvailableHours(disponibilidad, date);
                    _selectedHour = _availableHours.isEmpty ? null : _availableHours.first;
                  });
                },
              ),
            const SizedBox(height: 28),
            Text('Seleccionar hora', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            if (_selectedDate == null || _availableHours.isEmpty)
              _EmptyStateCard(
                icon: Icons.schedule_outlined,
                message: _selectedDate == null
                    ? 'Selecciona un día disponible para ver los horarios.'
                    : 'No hay horarios disponibles para el día elegido.',
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _availableHours.map((String hour) {
                  final bool isSelected = _selectedHour == hour;
                  return ChoiceChip(
                    label: Text(_formatHour(context, hour)),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: AppTextStyles.body.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedHour = hour;
                      });
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canConfirm ? () => _confirmarReserva(context, appState) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('Confirmar cita'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _canConfirm =>
      _servicio != null && _profesional != null && _selectedDate != null && _selectedHour != null;

  Future<void> _confirmarReserva(BuildContext context, AppState appState) async {
    final Servicio servicio = _servicio!;
    final Usuario profesional = _profesional!;
    final DateTime fecha = _selectedDate!;
    final String hora = _selectedHour!;

    final Cita? cita = appState.agendarCita(
      servicio: servicio,
      empleado: profesional,
      fecha: fecha,
      hora: hora,
    );

    if (cita == null) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Inicia sesión'),
          content: const Text('Debes iniciar sesión como cliente para agendar una cita.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Entendido')),
          ],
        ),
      );
      return;
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cita reservada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(servicio.nombre, style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Text('Profesional: ${profesional.nombre} ${profesional.apellido}'),
            Text('Fecha: ${Formatters.formatDate(fecha)}'),
            Text('Hora: ${_formatHour(context, hora)}'),
            const SizedBox(height: 12),
            const Text('Estado: Reservada'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  DateTime? _firstAvailableDate(List<Disponibilidad> availability) {
    final DateTime today = DateTime.now();
    final DateTime base = DateTime(today.year, today.month, today.day);
    for (int offset = 0; offset <= 60; offset++) {
      final DateTime candidate = base.add(Duration(days: offset));
      final bool matches =
          availability.any((Disponibilidad item) => _weekdayFromDia(item.dia) == candidate.weekday);
      if (matches) {
        return candidate;
      }
    }
    return null;
  }

  List<String> _buildAvailableHours(List<Disponibilidad> availability, DateTime date) {
    final int weekday = date.weekday;
    final List<Disponibilidad> dayAvailability =
        availability.where((Disponibilidad item) => _weekdayFromDia(item.dia) == weekday).toList();
    final List<String> slots = <String>[];
    final int stepMinutes = _servicio?.duracion ?? 60;
    for (final Disponibilidad item in dayAvailability) {
      final List<String> rangeSlots = _generateSlots(item.horaInicio, item.horaFin, stepMinutes);
      slots.addAll(rangeSlots);
    }
    final LinkedHashSet<String> unique = LinkedHashSet<String>.from(slots);
    return unique.toList()..sort();
  }

  List<String> _generateSlots(String start, String end, int stepMinutes) {
    final DateTime base = DateTime(2025, 1, 1);
    final DateTime startDate = DateTime(
      base.year,
      base.month,
      base.day,
      _parseTime(start).hour,
      _parseTime(start).minute,
    );
    final DateTime endDate = DateTime(
      base.year,
      base.month,
      base.day,
      _parseTime(end).hour,
      _parseTime(end).minute,
    );
    final Duration step = Duration(minutes: stepMinutes);
    final List<String> slots = <String>[];

    DateTime current = startDate;
    while (current.add(step).isBefore(endDate) || current.add(step).isAtSameMomentAs(endDate)) {
      slots.add(_formatRawTime(current));
      current = current.add(step);
    }
    return slots;
  }

  TimeOfDay _parseTime(String value) {
    final List<String> parts = value.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = parts.length > 1 ? int.parse(parts[1]) : 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatRawTime(DateTime dateTime) {
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatHour(BuildContext context, String raw) {
    final TimeOfDay time = _parseTime(raw);
    return MaterialLocalizations.of(context).formatTimeOfDay(time, alwaysUse24HourFormat: false);
  }

  int _weekdayFromDia(DiaSemana dia) {
    switch (dia) {
      case DiaSemana.lunes:
        return DateTime.monday;
      case DiaSemana.martes:
        return DateTime.tuesday;
      case DiaSemana.miercoles:
        return DateTime.wednesday;
      case DiaSemana.jueves:
        return DateTime.thursday;
      case DiaSemana.viernes:
        return DateTime.friday;
      case DiaSemana.sabado:
        return DateTime.saturday;
      case DiaSemana.domingo:
        return DateTime.sunday;
    }
  }
}

class _ServiceSummaryCard extends StatelessWidget {
  const _ServiceSummaryCard({required this.servicio});

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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cut, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(servicio.nombre, style: AppTextStyles.subtitle.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('Duración: ${servicio.duracion} min',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Formatters.formatCurrency(servicio.precio),
            style: AppTextStyles.subtitle.copyWith(color: AppColors.primary, fontSize: 18),
          ),
          if (servicio.categoria != null) ...[
            const SizedBox(height: 8),
            Text('Categoría: ${servicio.categoria}', style: AppTextStyles.body),
          ],
        ],
      ),
    );
  }
}

class _ProfessionalSummaryCard extends StatelessWidget {
  const _ProfessionalSummaryCard({required this.profesional});

  final Usuario profesional;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ),
          const SizedBox(height: 6),
          Text(
            'Especialista en cuidado personal',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 13),
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

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(icon, size: 42, color: AppColors.textSecondary),
          const SizedBox(height: 10),
          Text(
            message,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DayPicker extends StatelessWidget {
  const _DayPicker({
    required this.availability,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final List<Disponibilidad> availability;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year, now.month, now.day);
    final DateTime lastDate = firstDate.add(const Duration(days: 60));
    final Set<int> enabledWeekdays = availability.map((Disponibilidad item) => _weekdayFromDia(item.dia)).toSet();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: CalendarDatePicker(
        initialDate: selectedDate ?? firstDate,
        firstDate: firstDate,
        lastDate: lastDate,
        onDateChanged: onDateSelected,
        selectableDayPredicate: (DateTime day) {
          final bool isPast = day.isBefore(firstDate);
          return !isPast && enabledWeekdays.contains(day.weekday);
        },
      ),
    );
  }

  int _weekdayFromDia(DiaSemana dia) {
    switch (dia) {
      case DiaSemana.lunes:
        return DateTime.monday;
      case DiaSemana.martes:
        return DateTime.tuesday;
      case DiaSemana.miercoles:
        return DateTime.wednesday;
      case DiaSemana.jueves:
        return DateTime.thursday;
      case DiaSemana.viernes:
        return DateTime.friday;
      case DiaSemana.sabado:
        return DateTime.saturday;
      case DiaSemana.domingo:
        return DateTime.sunday;
    }
  }
}
