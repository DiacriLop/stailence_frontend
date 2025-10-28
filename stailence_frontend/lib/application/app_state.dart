import 'package:flutter/foundation.dart';

import '../core/exceptions/failures.dart';
import '../core/utils/formatters.dart';
import '../data/mock/mock_database.dart';
import '../data/repositories/auth_repository.dart';
import '../domain/entities/cita.dart';
import '../domain/entities/disponibilidad.dart';
import '../domain/entities/notificacion.dart';
import '../domain/entities/pago.dart';
import '../domain/entities/servicio.dart';
import '../domain/entities/usuario.dart';

class AppState extends ChangeNotifier {
  AppState({required AuthRepository authRepository})
      : _authRepository = authRepository,
        _database = MockDatabase.instance {
    final Usuario? persistedUser = _authRepository.currentUser;
    if (persistedUser != null) {
      _currentUser = _ensureMockUser(persistedUser);
    }
  }

  final AuthRepository _authRepository;
  final MockDatabase _database;

  Usuario? _currentUser;
  Usuario? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  bool _isAuthenticating = false;
  bool get isAuthenticating => _isAuthenticating;

  String? _authError;
  String? get authError => _authError;

  List<Servicio> get allServices => _database.servicios.toList();
  List<Usuario> get allEmployees =>
      _database.usuarios.where((Usuario user) => user.rol == UsuarioRol.empleado).toList();
  List<String> get serviceCategories => <String>['Todos', ..._database.serviceCategories()];

  List<Cita> get citasCliente =>
      _currentUser == null ? <Cita>[] : _database.citasForClient(_currentUser!.id);
  List<Notificacion> get notificacionesCliente =>
      _currentUser == null ? <Notificacion>[] : _database.notificationsForUser(_currentUser!.id);
  List<Pago> get pagosCliente =>
      _currentUser == null ? <Pago>[] : _database.paymentsForClient(_currentUser!.id);

  Future<String?> login({required String correo, required String contrasena}) async {
    _isAuthenticating = true;
    _authError = null;
    notifyListeners();

    try {
      final Usuario user =
          await _authRepository.login(correo: correo, contrasena: contrasena);
      _currentUser = _ensureMockUser(user, contrasena: contrasena);
      _authError = null;
      return null;
    } on Failure catch (failure) {
      _authError = failure.message;
      return failure.message;
    } catch (_) {
      _authError = 'Ocurrió un error inesperado al iniciar sesión';
      return _authError;
    } finally {
      _isAuthenticating = false;
      notifyListeners();
    }
  }

  Future<String?> register({
    required String nombre,
    required String apellido,
    required String correo,
    required String contrasena,
    required String confirmarContrasena,
  }) async {
    _isAuthenticating = true;
    _authError = null;
    notifyListeners();

    try {
      await _authRepository.register(
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        contrasena: contrasena,
        confirmarContrasena: confirmarContrasena,
      );
      final Usuario user =
          await _authRepository.login(correo: correo, contrasena: contrasena);
      _currentUser = _ensureMockUser(user, contrasena: contrasena);
      _authError = null;
      return null;
    } on Failure catch (failure) {
      _authError = failure.message;
      return failure.message;
    } catch (_) {
      _authError = 'Ocurrió un error inesperado al registrar el usuario';
      return _authError;
    } finally {
      _isAuthenticating = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  Usuario _ensureMockUser(Usuario backendUser, {String? contrasena}) {
    final Usuario? existing = _database.findUserByEmail(backendUser.correo);
    if (existing != null) {
      return existing;
    }
    return _database.registerClient(
      nombre: backendUser.nombre,
      apellido: backendUser.apellido,
      correo: backendUser.correo,
      contrasena: contrasena ?? '***',
    );
  }

  void actualizarPerfil({String? nombre, String? apellido, String? correo}) {
    final Usuario? user = _currentUser;
    if (user == null) {
      return;
    }
    _currentUser = _database.updateClientProfile(
      user,
      nombre: nombre,
      apellido: apellido,
      correo: correo,
    );
    notifyListeners();
  }

  String? cambiarContrasena({required String actual, required String nueva}) {
    final Usuario? user = _currentUser;
    if (user == null) {
      return 'No hay sesión activa';
    }
    if (user.contrasena != actual) {
      return 'La contraseña actual no es correcta';
    }
    _currentUser = _database.changePassword(user, nueva);
    notifyListeners();
    return null;
  }

  List<Servicio> serviciosFiltrados({String? categoria, int? empleadoId}) {
    final String? normalizedCategory =
        categoria == null || categoria.isEmpty || categoria == 'Todos' ? null : categoria;
    List<Servicio> servicios = _database.servicesByCategory(normalizedCategory);
    if (empleadoId != null) {
      final Set<int> serviciosEmpleado =
          _database.servicesByEmployee(empleadoId).map((Servicio servicio) => servicio.id).toSet();
      servicios = servicios.where((Servicio servicio) => serviciosEmpleado.contains(servicio.id)).toList();
    }
    return servicios;
  }

  List<Usuario> empleadosParaServicio(int servicioId) {
    return _database.employeesForService(servicioId);
  }

  List<Disponibilidad> disponibilidadEmpleado(int empleadoId) {
    return _database.availabilityForEmployee(empleadoId);
  }

  Servicio? servicioPorId(int id) {
    try {
      return allServices.firstWhere((Servicio servicio) => servicio.id == id);
    } catch (_) {
      return null;
    }
  }

  Usuario? empleadoPorId(int id) {
    try {
      return allEmployees.firstWhere((Usuario usuario) => usuario.id == id);
    } catch (_) {
      return null;
    }
  }

  Cita? agendarCita({
    required Servicio servicio,
    required Usuario empleado,
    required DateTime fecha,
    required String hora,
  }) {
    final Usuario? user = _currentUser;
    if (user == null) {
      return null;
    }
    final Cita cita = _database.scheduleAppointment(
      clienteId: user.id,
      servicio: servicio,
      empleado: empleado,
      fecha: fecha,
      hora: hora,
    );
    notifyListeners();
    return cita;
  }

  void actualizarEstadoCita(Cita cita, CitaEstado estado, {DateTime? fechaReal}) {
    _database.updateCitaEstado(cita, estado, fechaReal: fechaReal);
    notifyListeners();
  }

  Pago? registrarPago({required Cita cita, required double valor, required MetodoPago metodo}) {
    final Pago pago = _database.registrarPago(cita: cita, valor: valor, metodo: metodo);
    notifyListeners();
    return pago;
  }

  List<Cita> citasPorEstado(CitaEstado estado) {
    return citasCliente.where((Cita cita) => cita.estado == estado).toList();
  }

  String resumenCita(Cita cita) {
    final Servicio? servicio = servicioPorId(cita.idServicio ?? -1);
    final Usuario? empleado = empleadoPorId(cita.idEmpleado ?? -1);
    final String fecha = Formatters.formatDate(cita.fechaEstimada);
    return '${servicio?.nombre ?? 'Servicio'} · ${empleado?.nombre ?? 'Empleado'} · $fecha';
  }
}
