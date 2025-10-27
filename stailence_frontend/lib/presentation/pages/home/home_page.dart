import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/app_state.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/mock/negocios_mock.dart';
import '../../../domain/entities/negocio.dart';
import '../citas/citas_page.dart';
import '../negocios/negocio_detalle_page.dart';
import '../negocios/negocios_page.dart';
import '../perfil/perfil_page.dart';
import '../servicios/servicios_page.dart';
import 'ia_recomienda_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _BusinessSection extends StatelessWidget {
  const _BusinessSection({
    required this.businesses,
    required this.onViewAll,
    required this.onOpenDetail,
  });

  final List<Negocio> businesses;
  final VoidCallback onViewAll;
  final ValueChanged<Negocio> onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Negocios aliados', style: AppTextStyles.subtitle),
            TextButton(onPressed: onViewAll, child: const Text('Ver todos')),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 360,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            physics: const BouncingScrollPhysics(),
            itemCount: businesses.length,
            itemBuilder: (BuildContext context, int index) {
              final Negocio negocio = businesses[index];
              return Padding(
                padding: EdgeInsets.only(right: index == businesses.length - 1 ? 0 : 16),
                child: _BusinessCard(
                  negocio: negocio,
                  onTap: () => onOpenDetail(negocio),
                ),
              );
            },
          ),
        ),
      ],
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.elevatedSurface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 12),
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
                  Text(
                    negocio.nombre,
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (negocio.direccion != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, size: 18, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            negocio.direccion!,
                            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (negocio.horarioGeneral != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 18, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            negocio.horarioGeneral!,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _HomeDashboardView(
        onViewAllAppointments: _openAppointments,
        onViewAllServices: _goToServicesTab,
        onViewAllBusinesses: _openBusinessList,
        onOpenBusinessDetail: _openBusinessDetail,
      ),
      const ServiciosPage(),
      const IARecomiendaPage(),
      const PerfilPage(),
    ];
  }

  void _onDestinationSelected(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  void _openAppointments() {
    Navigator.of(context).pushNamed(CitasPage.routeName);
  }

  void _goToServicesTab() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _openBusinessList() {
    Navigator.of(context).pushNamed(NegociosPage.routeName);
  }

  void _openBusinessDetail(Negocio negocio) {
    Navigator.of(context).pushNamed(
      NegocioDetallePage.routeName,
      arguments: negocio,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: _BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onDestinationSelected,
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          items: [
            _buildItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Inicio',
              isSelected: currentIndex == 0,
            ),
            _buildItem(
              icon: Icons.map_outlined,
              activeIcon: Icons.map,
              label: 'Explorar',
              isSelected: currentIndex == 1,
            ),
            _buildItem(
              icon: Icons.cut,
              activeIcon: Icons.cut,
              label: 'IA',
              isSelected: currentIndex == 2,
              emphasize: true,
              tooltip: 'IA Recomienda',
            ),
            _buildItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Perfil',
              isSelected: currentIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    bool emphasize = false,
    String? tooltip,
  }) {
    return BottomNavigationBarItem(
      icon: _NavIcon(icon: icon, isSelected: false, emphasize: emphasize),
      activeIcon: _NavIcon(
        icon: activeIcon,
        isSelected: true,
        emphasize: emphasize,
      ),
      label: label,
      tooltip: tooltip,
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.isSelected,
    this.emphasize = false,
  });

  final IconData icon;
  final bool isSelected;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    if (emphasize) {
      final bool selected = isSelected;
      return Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface.withOpacity(0.18),
          shape: BoxShape.circle,
          border: selected
              ? null
              : Border.all(color: AppColors.primary.withOpacity(0.45), width: 1.4),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.28),
                offset: const Offset(0, 10),
                blurRadius: 20,
              ),
          ],
        ),
        child: Icon(icon, color: selected ? Colors.white : AppColors.primary, size: 24),
      );
    }

    final Color foreground = isSelected ? AppColors.primary : Colors.white70;
    return Icon(icon, color: foreground, size: 24);
  }
}

class _HomeDashboardView extends StatelessWidget {
  const _HomeDashboardView({
    required this.onViewAllAppointments,
    required this.onViewAllServices,
    required this.onViewAllBusinesses,
    required this.onOpenBusinessDetail,
  });

  final VoidCallback onViewAllAppointments;
  final VoidCallback onViewAllServices;
  final VoidCallback onViewAllBusinesses;
  final ValueChanged<Negocio> onOpenBusinessDetail;

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final String userName = appState.currentUser != null
        ? '${appState.currentUser!.nombre} ${appState.currentUser!.apellido}'.trim()
        : 'Invitado';

    final List<_Category> categories = const [
      _Category(icon: Icons.content_cut, label: 'Cortes'),
      _Category(icon: Icons.brush, label: 'Tintes'),
      _Category(icon: Icons.local_florist, label: 'Spa'),
      _Category(icon: Icons.more_horiz, label: 'Más'),
    ];

    final List<_Appointment> appointments = [
      _Appointment(
        date: DateTime(2025, 12, 22, 10, 0),
        business: 'Captain Barbershop',
        location: 'Manzana F casa 7· Tuluá, Col',
        services: 'Corte de Pelo Undercut · Afeitado Regular · Lavado',
        status: 'Recordatorio',
      ),
    ];

    final List<Negocio> negocios = NegociosMock.build();

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(onViewAllServices: onViewAllServices, displayName: userName),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _PromoCard(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _CategoryRow(categories: categories),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _BusinessSection(
                  businesses: negocios,
                  onViewAll: onViewAllBusinesses,
                  onOpenDetail: onOpenBusinessDetail,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _AppointmentsSection(
                  appointments: appointments,
                  onViewAll: onViewAllAppointments,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onViewAllServices, required this.displayName});

  final VoidCallback onViewAllServices;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, $displayName'.trim(),
                      style: AppTextStyles.subtitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Tuluá, Col',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SearchBar(onViewAllServices: onViewAllServices),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onViewAllServices});

  final VoidCallback onViewAllServices;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Buscar servicios',
                icon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onViewAllServices,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFBE0B), Color(0xFFFFA857)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '30% OFF',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Por tu cumpleaños 30%',
            style: AppTextStyles.headline.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Expanded(
            child: Text(
              'Obtén un descuento por cada servicio que utilices. Válido solo por hoy.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.categories});

  final List<_Category> categories;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories
          .map(
            (category) => Expanded(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(category.icon, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.label,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AppointmentsSection extends StatelessWidget {
  const _AppointmentsSection({
    required this.appointments,
    required this.onViewAll,
  });

  final List<_Appointment> appointments;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Próximas citas', style: AppTextStyles.subtitle),
            TextButton(onPressed: onViewAll, child: const Text('Ver todas')),
          ],
        ),
        const SizedBox(height: 12),
        ...appointments.map(
          (appointment) => _AppointmentCard(appointment: appointment),
        ),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final _Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          appointment.status,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        Formatters.formatDate(appointment.date),
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(appointment.business, style: AppTextStyles.subtitle),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          appointment.location,
                          style: AppTextStyles.body,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    appointment.services,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Detalles'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Category {
  const _Category({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _Appointment {
  _Appointment({
    required this.date,
    required this.business,
    required this.location,
    required this.services,
    required this.status,
  });

  final DateTime date;
  final String business;
  final String location;
  final String services;
  final String status;
}
