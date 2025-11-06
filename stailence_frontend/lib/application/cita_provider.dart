import 'package:flutter/foundation.dart';

import '../data/repositories/cita_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/cita_model.dart';
import '../domain/entities/cita.dart';

class CitaProvider with ChangeNotifier {
  CitaProvider({required this.citaRepository, required this.authRepository});

  final CitaRepository citaRepository;
  final AuthRepository authRepository;

  List<CitaModel> _citas = <CitaModel>[];
  bool _isLoading = false;
  String? _error;

  List<CitaModel> get citas => _citas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarCitas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final String? token = authRepository.token;
      if (token == null) throw Exception('No auth token available');
      _citas = await citaRepository.obtenerCitas(token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CitaModel> crearCita({
    required int servicioId,
    required DateTime fecha,
    required String hora,
    required int empleadoId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final String? token = authRepository.token;
      if (token == null) throw Exception('No auth token available');
      final CitaModel nueva = await citaRepository.crearCita(
        token: token,
        servicioId: servicioId,
        fecha: fecha,
        hora: hora,
        empleadoId: empleadoId,
      );
      _citas.add(nueva);
      return nueva;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelarCita(int citaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final String? token = authRepository.token;
      if (token == null) throw Exception('No auth token available');
      await citaRepository.cancelarCita(token, citaId);
      // update local state: mark as cancelada if present
      final int index = _citas.indexWhere((c) => c.id == citaId);
      if (index != -1) {
        final old = _citas[index];
        final updated = CitaModel(
          id: old.id,
          fechaEstimada: old.fechaEstimada,
          horaEstipulada: old.horaEstipulada,
          fechaReal: old.fechaReal,
          estado: CitaEstado.cancelada,
          idEmpleado: old.idEmpleado,
          idServicio: old.idServicio,
          idCliente: old.idCliente,
        );
        _citas[index] = updated;
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
