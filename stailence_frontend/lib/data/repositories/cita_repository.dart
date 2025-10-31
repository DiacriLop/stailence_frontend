import '../../core/exceptions/failures.dart';
import '../models/cita_model.dart';
import '../services/cita_service.dart';

class CitaRepository {
  CitaRepository({required this.service});

  final CitaService service;

  Future<List<CitaModel>> obtenerCitas(String token) async {
    try {
      return await service.obtenerCitas(token);
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
