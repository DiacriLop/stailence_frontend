import '../../core/exceptions/failures.dart';
import '../../domain/entities/empleado_servicio.dart';
import '../models/empleado_servicio_model.dart';
import '../services/empleado_servicio_service.dart';
import 'auth_repository.dart';

class EmpleadoServicioRepository {
  EmpleadoServicioRepository({
    required this.service,
    required this.authRepository,
  });

  final EmpleadoServicioService service;
  final AuthRepository authRepository;

  Future<List<EmpleadoServicio>> obtenerEmpleadosPorServicio(
    int servicioId,
  ) async {
    try {
      final String? token = authRepository.token;
      print(
        '[EmpleadoServicioRepository] obtenerEmpleadosPorServicio servicioId=$servicioId tokenPresent=${token != null && token.isNotEmpty}',
      );
      if (token == null || token.isEmpty) {
        // No session: explicitly bubble up CacheFailure but log for debug
        print(
          '[EmpleadoServicioRepository] No hay sesión activa (token vacío)',
        );
        throw const CacheFailure('No hay sesión activa');
      }
      final List<EmpleadoServicioModel> modelos = await service
          .obtenerEmpleadosPorServicio(servicioId: servicioId, token: token);
      print(
        '[EmpleadoServicioRepository] modelos recibidos: ${modelos.length}',
      );
      // Convert to domain EmpleadoServicio list
      return List<EmpleadoServicio>.from(modelos);
    } on ServerFailure catch (e) {
      print('[EmpleadoServicioRepository] ServerFailure: ${e.message}');
      if (e.message.toLowerCase().contains('unauthorized') ||
          e.message.contains('401') ||
          e.message.contains('403')) {
        await authRepository.logout();
        throw const CacheFailure(
          'Sesión expirada. Por favor, inicia sesión de nuevo.',
        );
      }
      rethrow;
    } on Failure {
      print('[EmpleadoServicioRepository] Failure caught');
      rethrow;
    } catch (e) {
      print('[EmpleadoServicioRepository] catch error: $e');
      throw const ServerFailure('Error al cargar empleados del servicio');
    }
  }
}
