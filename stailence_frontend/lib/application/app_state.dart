import 'package:flutter/foundation.dart';

import '../core/utils/formatters.dart';
import '../data/mock/mock_database.dart';
import '../domain/entities/cita.dart';
import '../domain/entities/disponibilidad.dart';
import '../domain/entities/notificacion.dart';
import '../domain/entities/pago.dart';
import '../domain/entities/servicio.dart';
import '../domain/entities/usuario.dart';

class AppState extends ChangeNotifier {
  AppState();

  final MockDatabase _database = MockDatabase.instance;

  Usuario? _currentUser;
  Usuario? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

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
    final Usuario? user = _database.findUserByCredentials(correo, contrasena);
    if (user == null || user.rol != UsuarioRol.cliente) {
      return 'Credenciales inválidas o rol no permitido';
    }
    _currentUser = user;
    notifyListeners();
    return null;
  }

  Future<String?> register({
    required String nombre,
    required String apellido,
    required String correo,
    required String contrasena,
  }) async {
    final Usuario? existing = _database.findUserByEmail(correo);
    if (existing != null) {
      return 'El correo ya está registrado';
    }
    final Usuario newUser = _database.registerClient(
      nombre: nombre,
      apellido: apellido,
      correo: correo,
      contrasena: contrasena,
    );
    _currentUser = newUser;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
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
