import 'package:stailence_frontend/core/exceptions/failures.dart';
import 'package:stailence_frontend/data/models/servicio_model.dart';
import 'package:stailence_frontend/data/models/empleado_model.dart';
import 'package:stailence_frontend/data/models/horario_disponible_model.dart';
import 'package:stailence_frontend/data/services/servicio_service.dart';

class ServicioRepository {
  ServicioRepository({required this.service});

  final ServicioService service;

  Future<List<ServicioModel>> obtenerServicios() async {
    try {
      return await service.obtenerServicios();
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar los servicios');
    }
  }

  Future<List<EmpleadoModel>> obtenerEmpleadosPorServicio(int servicioId) async {
    try {
      return await service.obtenerEmpleadosPorServicio(servicioId);
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
      return await service.obtenerHorariosDisponibles(
        servicioId: servicioId,
        empleadoId: empleadoId,
        fecha: fecha,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar los horarios disponibles');
    }
  }
}
