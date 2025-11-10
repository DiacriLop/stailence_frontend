import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../application/app_state.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../domain/entities/servicio.dart';
import '../../../domain/entities/usuario.dart';
import 'servicio_detalle_page.dart';

class ServiciosPage extends StatefulWidget {
  const ServiciosPage({super.key, required this.servicios, this.idNegocio});

  static const String routeName = '/servicios';

  final List<Servicio> servicios;
  final int? idNegocio;

  @override
  State<ServiciosPage> createState() => _ServiciosPageState();
}

class _ServiciosPageState extends State<ServiciosPage> {
  String _selectedCategory = 'Todos';
  int? _selectedEmployeeId;

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final List<String> categories = appState.serviceCategories;
    final List<Usuario> employees = appState.allEmployees;

    // Filtrar servicios por negocio si se especifica
    List<Servicio> serviciosFiltrados = widget.servicios;
    if (widget.idNegocio != null) {
      serviciosFiltrados = serviciosFiltrados
          .where((s) => s.idNegocio == widget.idNegocio)
          .toList();
    }

    // Aplicar filtros de categoría y empleado
    if (_selectedCategory != 'Todos') {
      serviciosFiltrados = serviciosFiltrados
          .where((s) => s.categoria == _selectedCategory)
          .toList();
    }
    if (_selectedEmployeeId != null) {
      final serviciosEmpleado = appState.serviciosFiltrados(
        empleadoId: _selectedEmployeeId,
      );
      serviciosFiltrados = serviciosFiltrados
          .where((s) => serviciosEmpleado.any((se) => se.id == s.id))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.serviciosTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encuentra el servicio ideal para ti',
              style: AppTextStyles.headline.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 16),
            Text('Filtrar por categoría', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            _CategoryFilter(
              categories: categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (String category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 24),
            Text('Filtrar por profesional', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            _EmployeeDropdown(
              employees: employees,
              selectedEmployeeId: _selectedEmployeeId,
              onChanged: (int? value) {
                setState(() {
                  _selectedEmployeeId = value;
                });
              },
            ),
            const SizedBox(height: 24),
            Text('Servicios disponibles', style: AppTextStyles.subtitle),
            const SizedBox(height: 12),
            if (serviciosFiltrados.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: AppColors.elevatedSurface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.search_off_outlined,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No encontramos servicios con los filtros seleccionados.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: serviciosFiltrados.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (BuildContext context, int index) {
                  final Servicio servicio = serviciosFiltrados[index];
                  final List<Usuario> profesionales = appState
                      .empleadosParaServicio(servicio.id);
                  return _ServiceCard(
                    servicio: servicio,
                    profesionales: profesionales,
                    onTap: () => _openServiceDetail(context, servicio),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openServiceDetail(BuildContext context, Servicio servicio) {
    Navigator.of(
      context,
    ).pushNamed(ServicioDetallePage.routeName, arguments: servicio);
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((String category) {
        final bool isSelected = category == selectedCategory;
        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          selectedColor: AppColors.primary,
          labelStyle: AppTextStyles.body.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          backgroundColor: AppColors.elevatedSurface,
          onSelected: (_) => onCategorySelected(category),
        );
      }).toList(),
    );
  }
}

class _EmployeeDropdown extends StatelessWidget {
  const _EmployeeDropdown({
    required this.employees,
    required this.selectedEmployeeId,
    required this.onChanged,
  });

  final List<Usuario> employees;
  final int? selectedEmployeeId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int?>(
      value: selectedEmployeeId,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        prefixIcon: Icon(Icons.person_outline),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      hint: const Text('Todos los profesionales'),
      items: <DropdownMenuItem<int?>>[
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Todos los profesionales'),
        ),
        ...employees.map(
          (Usuario employee) => DropdownMenuItem<int?>(
            value: employee.id,
            child: Text('${employee.nombre} ${employee.apellido}'),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.servicio,
    required this.profesionales,
    required this.onTap,
  });

  final Servicio servicio;
  final List<Usuario> profesionales;
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        Text(
                          servicio.nombre,
                          style: AppTextStyles.subtitle.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Duración: ${servicio.duracion} min',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.formatCurrency(servicio.precio),
                          style: AppTextStyles.subtitle.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        if (servicio.categoria != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Categoría: ${servicio.categoria}',
                            style: AppTextStyles.body,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.people_alt_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      profesionales.isEmpty
                          ? 'Sin profesionales asignados'
                          : '${profesionales.length} profesional(es) disponible(s)',
                      style: AppTextStyles.body,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Agendar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
