import 'package:flutter/material.dart';

import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/citas/cita_detalle_page.dart';
import 'presentation/pages/citas/citas_page.dart';
import 'presentation/pages/citas/nueva_cita_page.dart';
import 'domain/entities/servicio.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/home/tab_admin.dart';
import 'presentation/pages/home/tab_client.dart';
import 'presentation/pages/home/tab_empleado.dart';
import 'data/mock/negocios_mock.dart';
import 'domain/entities/negocio.dart';
import 'presentation/pages/negocios/negocio_detalle_page.dart';
import 'presentation/pages/negocios/negocios_page.dart';
import 'presentation/pages/notificaciones/notificaciones_page.dart';
import 'presentation/pages/pagos/pagos_page.dart';
import 'presentation/pages/perfil/perfil_page.dart';
import 'presentation/pages/servicios/servicio_detalle_page.dart';
import 'presentation/pages/servicios/servicios_page.dart';
import 'presentation/pages/splash/splash_page.dart';

class AppRouter {
  const AppRouter._();

  static const String initialRoute = HomePage.routeName;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashPage.routeName:
        return _buildPage(const SplashPage());
      case LoginPage.routeName:
        return _buildPage(const LoginPage());
      case RegisterPage.routeName:
        return _buildPage(const RegisterPage());
      case HomePage.routeName:
        return _buildPage(const HomePage());
      case TabClient.routeName:
        return _buildPage(const TabClient());
      case TabEmpleado.routeName:
        return _buildPage(const TabEmpleado());
      case TabAdmin.routeName:
        return _buildPage(const TabAdmin());
      case CitasPage.routeName:
        return _buildPage(const CitasPage());
      case CitaDetallePage.routeName:
        return _buildPage(const CitaDetallePage());
      case NuevaCitaPage.routeName:
        final NuevaCitaPageArguments? nuevaCitaArgs =
            settings.arguments as NuevaCitaPageArguments?;
        if (nuevaCitaArgs == null) {
          return _buildPage(const _RouteErrorPage(message: 'Información de cita no disponible'));
        }
        return _buildPage(NuevaCitaPage(arguments: nuevaCitaArgs));
      case ServiciosPage.routeName:
        return _buildPage(const ServiciosPage());
      case NegociosPage.routeName:
        return _buildPage(NegociosPage(negocios: NegociosMock.build()));
      case NegocioDetallePage.routeName:
        final Negocio? negocio = settings.arguments as Negocio?;
        if (negocio == null) {
          return _buildPage(const _RouteErrorPage(message: 'Negocio no disponible'));
        }
        return _buildPage(NegocioDetallePage(negocio: negocio));
      case ServicioDetallePage.routeName:
        final Servicio? servicio = settings.arguments as Servicio?;
        if (servicio == null) {
          return _buildPage(const _RouteErrorPage(message: 'Servicio no disponible'));
        }
        return _buildPage(ServicioDetallePage(servicio: servicio));
      case NotificacionesPage.routeName:
        return _buildPage(const NotificacionesPage());
      case PagosPage.routeName:
        return _buildPage(const PagosPage());
      case PerfilPage.routeName:
        return _buildPage(const PerfilPage());
      default:
        return _buildPage(const SplashPage());
    }
  }

  static MaterialPageRoute<dynamic> _buildPage(Widget page) {
    return MaterialPageRoute<dynamic>(builder: (_) => page);
  }
}

class _RouteErrorPage extends StatelessWidget {
  const _RouteErrorPage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(message)),
    );
  }
}
