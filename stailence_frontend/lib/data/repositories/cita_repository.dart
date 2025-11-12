import '../../core/exceptions/failures.dart';
import '../../domain/entities/cita.dart';
import '../models/cita_model.dart';
import '../services/cita_service.dart';
import 'auth_repository.dart';

class CitaRepository {
  CitaRepository({required this.service, required this.authRepository});

  final CitaService service;
  final AuthRepository authRepository;

  Future<List<Cita>> obtenerCitas() async {
    try {
      final String? token = authRepository.token;
      if (token == null || token.isEmpty) {
        throw const CacheFailure('No hay sesión activa');
      }
      final List<CitaModel> modelos = await service.obtenerCitas(token: token);
      // Convert to domain Cita list (models extend Cita)
      return List<Cita>.from(modelos);
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
      throw const ServerFailure('Error al cargar las citas');
    }
  }

  Future<CitaModel> crearCita({
    required String token,
    required int servicioId,
    required DateTime fecha,
    required String hora,
    required int empleadoId,
  }) async {
    try {
      return await service.crearCita(
        token: token,
        servicioId: servicioId,
        fecha: fecha,
        hora: hora,
        empleadoId: empleadoId,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al crear la cita');
    }
  }

  Future<void> cancelarCita(String token, int citaId) async {
    try {
      await service.cancelarCita(token, citaId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cancelar la cita');
    }
  }
}
