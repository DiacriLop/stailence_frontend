import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import 'nueva_cita_page.dart';

class CitasPage extends StatelessWidget {
  const CitasPage({super.key});

  static const String routeName = '/citas';

  @override
  Widget build(BuildContext context) {
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
        body: TabBarView(
          children: [
            _AppointmentList(appointments: _upcomingAppointments, emptyMessage: 'No tienes próximas citas.'),
            _AppointmentList(appointments: _completedAppointments, emptyMessage: 'Aún no hay citas completadas.'),
            _AppointmentList(appointments: _cancelledAppointments, emptyMessage: 'Aún no hay citas canceladas.'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pushNamed(NuevaCitaPage.routeName),
          icon: const Icon(Icons.add),
          label: const Text('Reservar cita'),
        ),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  const _AppointmentList({
    required this.appointments,
    required this.emptyMessage,
  });

  final List<_AppointmentItem> appointments;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Text(emptyMessage, style: AppTextStyles.body),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 96),
      itemCount: appointments.length,
      itemBuilder: (BuildContext context, int index) {
        final appointment = appointments[index];
        return _AppointmentTile(item: appointment);
      },
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({required this.item});

  final _AppointmentItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(item.date, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.statusColor.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(color: item.statusColor, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(item.business, style: AppTextStyles.subtitle),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(child: Text(item.location, style: AppTextStyles.body)),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.services, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Detalles'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Reprogramar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppointmentItem {
  const _AppointmentItem({
    required this.date,
    required this.business,
    required this.location,
    required this.services,
    required this.status,
    required this.statusColor,
  });

  final String date;
  final String business;
  final String location;
  final String services;
  final String status;
  final Color statusColor;
}

const List<_AppointmentItem> _upcomingAppointments = [
  _AppointmentItem(
    date: '20 Oct 2025 · 11:00 AM',
    business: 'The Gentleman’s Den',
    location: 'Carrera 45 # 12-34 · Tuluá, Col',
    services: 'Corte de pelo · Barbería · Spa facial',
    status: 'Pendiente',
    statusColor: AppColors.primary,
  ),
];

const List<_AppointmentItem> _completedAppointments = [
  _AppointmentItem(
    date: '05 Sep 2025 · 03:00 PM',
    business: 'Classic Cuts Barber',
    location: 'Av. Central 23-55 · Tuluá, Col',
    services: 'Afeitado clásico · Mascarilla',
    status: 'Completado',
    statusColor: AppColors.success,
  ),
];

const List<_AppointmentItem> _cancelledAppointments = [
  _AppointmentItem(
    date: '14 Ago 2025 · 10:30 AM',
    business: 'Urban Style Studio',
    location: 'Calle 10 # 5-20 · Tuluá, Col',
    services: 'Coloración · Tratamiento capilar',
    status: 'Cancelado',
    statusColor: AppColors.error,
  ),
];
