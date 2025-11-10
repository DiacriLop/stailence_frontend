import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../application/app_state.dart';
import '../../../data/repositories/negocio_repository.dart';
import '../../../injection_container.dart';
import '../../../domain/entities/negocio.dart';
import 'negocios_page.dart';
import 'package:stailence_frontend/presentation/pages/auth/login_page.dart';
import '../../../core/exceptions/failures.dart';

class NegociosLoaderPage extends StatefulWidget {
  const NegociosLoaderPage({super.key});

  static const String routeName = '/negocios';

  @override
  State<NegociosLoaderPage> createState() => _NegociosLoaderPageState();
}

class _NegociosLoaderPageState extends State<NegociosLoaderPage> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNegocios();
  }

  Future<void> _loadNegocios() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final NegocioRepository repo = getIt<NegocioRepository>();
      final List<Negocio> negocios = await repo.obtenerNegocios();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => NegociosPage(negocios: negocios)),
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
        _error = 'Ocurrió un error al cargar los negocios';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Negocios')),
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
                    onPressed: _loadNegocios,
                    child: const Text('Reintentar'),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
