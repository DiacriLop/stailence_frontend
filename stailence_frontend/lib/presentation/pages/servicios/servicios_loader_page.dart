import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/app_state.dart';
import '../../../data/repositories/servicio_repository.dart';
import '../../../domain/entities/servicio.dart';
import '../../../injection_container.dart';
import '../auth/login_page.dart';
import '../../../core/exceptions/failures.dart';
import 'servicios_page.dart';

class ServiciosLoaderPage extends StatefulWidget {
  const ServiciosLoaderPage({super.key});

  static const String routeName = '/servicios';

  @override
  State<ServiciosLoaderPage> createState() => _ServiciosLoaderPageState();
}

class _ServiciosLoaderPageState extends State<ServiciosLoaderPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServicios();
  }

  Future<void> _loadServicios() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ServicioRepository repo = getIt<ServicioRepository>();
      final List<Servicio> servicios = await repo.obtenerServicios();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ServiciosPage(servicios: servicios)),
      );
    } on CacheFailure catch (_) {
      // Sesión expirada o no hay token
      if (!mounted) return;
      // Forzamos logout y navegamos al login
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.logout();
      Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
    } on Failure catch (f) {
      setState(() {
        _error = f.message;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ocurrió un error al cargar los servicios';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _loadServicios,
                    child: const Text('Reintentar'),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
