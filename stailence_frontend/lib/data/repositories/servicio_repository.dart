import '../../core/exceptions/failures.dart';
import '../models/servicio_model.dart';
import '../../domain/entities/servicio.dart';
import '../models/empleado_model.dart';
import '../models/horario_disponible_model.dart';
import '../services/servicio_service.dart';
import 'auth_repository.dart';

class ServicioRepository {
  ServicioRepository({required this.service, required this.authRepository});

  final ServicioService service;
  final AuthRepository authRepository;

  Future<List<Servicio>> obtenerServicios() async {
    try {
      final String? token = authRepository.token;
      if (token == null || token.isEmpty) {
        throw const CacheFailure('No hay sesión activa');
      }
      final List<ServicioModel> modelos = await service.obtenerServicios(
        token: token,
      );
      // Convert to domain Servicio list (models extend Servicio)
      return List<Servicio>.from(modelos);
    } on ServerFailure catch (e) {
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
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar los servicios');
    }
  }

  Future<List<EmpleadoModel>> obtenerEmpleadosPorServicio(
    int servicioId,
  ) async {
    try {
      final String? token = authRepository.token;
      if (token == null || token.isEmpty) {
        throw const CacheFailure('No hay sesión activa');
      }
      return await service.obtenerEmpleadosPorServicio(
        servicioId,
        token: token,
      );
    } on ServerFailure catch (e) {
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
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar los empleados');
    }
  }

  Future<List<HorarioDisponibleModel>> obtenerHorariosDisponibles({
    required int servicioId,
    required int empleadoId,
    required DateTime fecha,
  }) async {
    try {
      final String? token = authRepository.token;
      if (token == null || token.isEmpty) {
        throw const CacheFailure('No hay sesión activa');
      }
      return await service.obtenerHorariosDisponibles(
        servicioId: servicioId,
        empleadoId: empleadoId,
        fecha: fecha,
        token: token,
      );
    } on ServerFailure catch (e) {
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
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar los horarios disponibles');
    }
  }

  Future<List<Servicio>> obtenerServiciosPorNegocio(int negocioId) async {
    try {
      final String? token = authRepository.token;
      if (token == null || token.isEmpty) {
        throw const CacheFailure('No hay sesión activa');
      }
      // Get all services and filter by negocioId on the client side
      // (the backend endpoint /api/negocios/{id}/servicios returns 403)
      final List<ServicioModel> allServices = await service.obtenerServicios(
        token: token,
      );

      // Filter services that belong to the requested negocio
      final List<ServicioModel> filteredServicios = allServices
          .where((servicio) => servicio.idNegocio == negocioId)
          .toList();

      return List<Servicio>.from(filteredServicios);
    } on ServerFailure catch (e) {
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
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar los servicios del negocio');
    }
  }
}
