import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/app_state.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../auth/login_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  static const String routeName = '/perfil';

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _receiveNotifications = true;
  String _selectedGender = 'Femenino';

  @override
  Widget build(BuildContext context) {
    final AppState appState = context.watch<AppState>();
    final bool isLoggedIn = appState.isLoggedIn;
    final user = appState.currentUser;
    final String displayName = user != null ? '${user.nombre} ${user.apellido}'.trim() : 'Invitado';
    final String displayEmail = user?.correo ?? 'Sin correo';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Tu Perfil'),
        backgroundColor: Colors.transparent,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              )
            : null,
      ),
      body: Stack(
        children: [
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.heroGradientStart, AppColors.heroGradientEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 32),
              child: Column(
                children: [
                  _ProfileHeader(
                    onEdit: () {},
                    name: displayName,
                    email: displayEmail,
                  ),
                  const SizedBox(height: 24),
                  _ProfileForm(
                    isLoggedIn: isLoggedIn,
                    name: displayName,
                    email: displayEmail,
                    selectedGender: _selectedGender,
                    onGenderChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedGender = value;
                        });
                      }
                    },
                    receiveNotifications: _receiveNotifications,
                    onNotificationsChanged: (value) {
                      setState(() {
                        _receiveNotifications = value;
                      });
                    },
                    onLogout: isLoggedIn
                        ? () async {
                            // Capture navigator before awaiting logout to avoid using
                            // BuildContext across async gaps.
                            final NavigatorState navigator = Navigator.of(context);
                            await context.read<AppState>().logout();
                            if (!mounted) {
                              return;
                            }
                            navigator.pushNamedAndRemoveUntil(
                              LoginPage.routeName,
                              (route) => false,
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onEdit, required this.name, required this.email});

  final VoidCallback onEdit;
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, size: 54, color: Colors.white),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(name, style: AppTextStyles.subtitle.copyWith(fontSize: 22)),
          const SizedBox(height: 6),
          Text(email, style: AppTextStyles.body),
        ],
      ),
    );
  }
}

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.isLoggedIn,
    required this.name,
    required this.email,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.receiveNotifications,
    required this.onNotificationsChanged,
    this.onLogout,
  });

  final bool isLoggedIn;
  final String name;
  final String email;
  final String selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final bool receiveNotifications;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
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
          Text('Información personal', style: AppTextStyles.subtitle),
          const SizedBox(height: 20),
          _ProfileField(
            label: 'Nombre completo',
            hint: 'Tu nombre',
            initialValue: name,
            readOnly: true,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _ProfileField(
            label: 'Correo electrónico',
            hint: 'Tu correo',
            initialValue: email,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          const _ProfileField(
            label: 'Número de teléfono',
            hint: '+57 300 123 4567',
            keyboardType: TextInputType.phone,
            initialValue: '+57 300 123 4567',
            icon: Icons.phone_outlined,
          ),
          const SizedBox(height: 16),
          const _ProfileField(
            label: 'Fecha de nacimiento',
            hint: 'DD/MM/AAAA',
            readOnly: true,
            initialValue: '22/11/1996',
            icon: Icons.cake_outlined,
            trailing: Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedGender,
            decoration: const InputDecoration(
              labelText: 'Género',
              prefixIcon: Icon(Icons.wc_outlined),
            ),
            items: const [
              DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
              DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
              DropdownMenuItem(value: 'Otro', child: Text('Otro')),
              DropdownMenuItem(value: 'Prefiero no decir', child: Text('Prefiero no decir')),
            ],
            onChanged: onGenderChanged,
          ),
          const SizedBox(height: 16),
          const _ProfileField(
            label: 'Dirección',
            hint: 'Tu dirección',
            initialValue: 'Carrera 23 # 12-34 · Tuluá, Col',
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 16),
          SwitchListTile.adaptive(
            value: receiveNotifications,
            onChanged: onNotificationsChanged,
            contentPadding: EdgeInsets.zero,
            title: Text('Recibir notificaciones', style: AppTextStyles.subtitle.copyWith(fontSize: 16)),
            subtitle: Text(
              'Mantente informada sobre promociones y recordatorios de citas.',
              style: AppTextStyles.body,
            ),
            activeColor: AppColors.primary,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Guardar cambios'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onLogout,
              child: Text(isLoggedIn ? 'Cerrar sesión' : 'Inicia sesión'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.hint,
    this.initialValue,
    this.keyboardType,
    this.readOnly = false,
    this.icon,
    this.trailing,
  });

  final String label;
  final String hint;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool readOnly;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: trailing,
      ),
    );
  }
}
