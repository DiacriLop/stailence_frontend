import 'dart:collection';

import '../../core/utils/formatters.dart';
import '../../domain/entities/cita.dart';
import '../../domain/entities/disponibilidad.dart';
import '../../domain/entities/empleado_servicio.dart';
import '../../domain/entities/negocio.dart';
import '../../domain/entities/notificacion.dart';
import '../../domain/entities/pago.dart';
import '../../domain/entities/servicio.dart';
import '../../domain/entities/usuario.dart';
import 'disponibilidad_mock.dart';
import 'empleado_servicio_mock.dart';
import 'negocios_mock.dart';
import 'servicios_mock.dart';
import 'usuarios_mock.dart';

class MockDatabase {
  MockDatabase._();

  static final MockDatabase instance = MockDatabase._();

  final List<Negocio> _negocios = List<Negocio>.from(NegociosMock.build());
  final List<Servicio> _servicios = List<Servicio>.from(ServiciosMock.build());
  final List<Usuario> _usuarios = List<Usuario>.from(UsuariosMock.build());
  final List<Disponibilidad> _disponibilidades = List<Disponibilidad>.from(DisponibilidadMock.build());
  final List<EmpleadoServicio> _empleadoServicios = List<EmpleadoServicio>.from(EmpleadoServicioMock.build());
  final List<Cita> _citas = <Cita>[];
  final List<Notificacion> _notificaciones = <Notificacion>[];
  final List<Pago> _pagos = <Pago>[];

  UnmodifiableListView<Usuario> get usuarios => UnmodifiableListView<Usuario>(_usuarios);
  UnmodifiableListView<Negocio> get negocios => UnmodifiableListView<Negocio>(_negocios);
  UnmodifiableListView<Servicio> get servicios => UnmodifiableListView<Servicio>(_servicios);
  UnmodifiableListView<Disponibilidad> get disponibilidades => UnmodifiableListView<Disponibilidad>(_disponibilidades);
  UnmodifiableListView<Cita> get citas => UnmodifiableListView<Cita>(_citas);
  UnmodifiableListView<Notificacion> get notificaciones => UnmodifiableListView<Notificacion>(_notificaciones);
  UnmodifiableListView<Pago> get pagos => UnmodifiableListView<Pago>(_pagos);

  Usuario? findUserByCredentials(String correo, String contrasena) {
    try {
      return _usuarios.firstWhere(
        (Usuario user) => user.correo.toLowerCase() == correo.toLowerCase() && user.contrasena == contrasena,
      );
    } catch (_) {
      return null;
    }
  }

  Usuario? findUserByEmail(String correo) {
    try {
      return _usuarios.firstWhere((Usuario user) => user.correo.toLowerCase() == correo.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  Usuario registerClient({
    required String nombre,
    required String apellido,
    required String correo,
    required String contrasena,
  }) {
    final Usuario newUser = Usuario(
      id: _usuarios.isEmpty ? 1 : _usuarios.last.id + 1,
      nombre: nombre,
      apellido: apellido,
      correo: correo,
      contrasena: contrasena,
      rol: UsuarioRol.cliente,
    );
    _usuarios.add(newUser);
    return newUser;
  }

  Usuario updateClientProfile(Usuario original, {String? nombre, String? apellido, String? correo}) {
    final Usuario updated = Usuario(
      id: original.id,
      nombre: nombre ?? original.nombre,
      apellido: apellido ?? original.apellido,
      correo: correo ?? original.correo,
      contrasena: original.contrasena,
      rol: original.rol,
      idTipo: original.idTipo,
      idNegocio: original.idNegocio,
    );
    final int index = _usuarios.indexWhere((Usuario user) => user.id == original.id);
    if (index != -1) {
      _usuarios[index] = updated;
    }
    return updated;
  }

  Usuario changePassword(Usuario original, String nuevaContrasena) {
    final Usuario updated = Usuario(
      id: original.id,
      nombre: original.nombre,
      apellido: original.apellido,
      correo: original.correo,
      contrasena: nuevaContrasena,
      rol: original.rol,
      idTipo: original.idTipo,
      idNegocio: original.idNegocio,
    );
    final int index = _usuarios.indexWhere((Usuario user) => user.id == original.id);
    if (index != -1) {
      _usuarios[index] = updated;
    }
    return updated;
  }

  List<Usuario> employeesForService(int serviceId) {
    final List<int> employeeIds = _empleadoServicios
        .where((EmpleadoServicio relation) => relation.idServicio == serviceId)
        .map((EmpleadoServicio relation) => relation.idEmpleado)
        .toList();
    return _usuarios.where((Usuario user) => employeeIds.contains(user.id)).toList();
  }

  List<String> serviceCategories() {
    final Set<String> categories = <String>{};
    for (final Servicio servicio in _servicios) {
      if (servicio.categoria != null) {
        categories.add(servicio.categoria!);
      }
    }
    return categories.toList()..sort();
  }

  List<Servicio> servicesByCategory(String? category) {
    if (category == null || category.isEmpty || category == 'Todos') {
      return List<Servicio>.from(_servicios);
    }
    return _servicios.where((Servicio servicio) => servicio.categoria == category).toList();
  }

  List<Servicio> servicesByEmployee(int? employeeId) {
    if (employeeId == null) {
      return List<Servicio>.from(_servicios);
    }
    final Set<int> serviceIds = _empleadoServicios
        .where((EmpleadoServicio relation) => relation.idEmpleado == employeeId)
        .map((EmpleadoServicio relation) => relation.idServicio)
        .toSet();
    return _servicios.where((Servicio servicio) => serviceIds.contains(servicio.id)).toList();
  }

  List<Disponibilidad> availabilityForEmployee(int empleadoId) {
    return _disponibilidades.where((Disponibilidad item) => item.idEmpleado == empleadoId).toList();
  }

  List<Cita> citasForClient(int clientId) {
    return _citas.where((Cita cita) => cita.idCliente == clientId).toList();
  }

  List<Notificacion> notificationsForUser(int userId) {
    return _notificaciones.where((Notificacion item) => item.idUsuario == userId).toList();
  }

  List<Pago> paymentsForClient(int clientId) {
    final Set<int> clientCitas = _citas.where((Cita cita) => cita.idCliente == clientId).map((Cita c) => c.id).toSet();
    return _pagos.where((Pago pago) => pago.idCita != null && clientCitas.contains(pago.idCita!)).toList();
  }

  Cita scheduleAppointment({
    required int clienteId,
    required Servicio servicio,
    required Usuario empleado,
    required DateTime fecha,
    required String hora,
  }) {
    final int newId = _citas.isEmpty ? 1 : _citas.last.id + 1;
    final Cita cita = Cita(
      id: newId,
      fechaEstimada: DateTime(fecha.year, fecha.month, fecha.day),
      horaEstipulada: hora,
      estado: CitaEstado.reservada,
      idEmpleado: empleado.id,
      idServicio: servicio.id,
      idCliente: clienteId,
    );
    _citas.add(cita);

    final Notificacion reminder = Notificacion(
      id: _notificaciones.isEmpty ? 1 : _notificaciones.last.id + 1,
      mensajeRecordatorio:
          'Recordatorio: ${servicio.nombre} el ${Formatters.formatDate(fecha)} a las $hora con ${empleado.nombre}.',
      fecha: DateTime.now(),
      estado: EstadoNotificacion.pendiente,
      idUsuario: clienteId,
      idCita: cita.id,
    );
    _notificaciones.add(reminder);

    return cita;
  }

  void updateCitaEstado(Cita cita, CitaEstado estado, {DateTime? fechaReal}) {
    final int index = _citas.indexWhere((Cita item) => item.id == cita.id);
    if (index == -1) {
      return;
    }
    final Cita updated = Cita(
      id: cita.id,
      fechaEstimada: cita.fechaEstimada,
      horaEstipulada: cita.horaEstipulada,
      estado: estado,
      fechaReal: fechaReal,
      idEmpleado: cita.idEmpleado,
      idServicio: cita.idServicio,
      idCliente: cita.idCliente,
    );
    _citas[index] = updated;
  }

  Pago registrarPago({
    required Cita cita,
    required double valor,
    required MetodoPago metodo,
  }) {
    final Pago pago = Pago(
      id: _pagos.isEmpty ? 1 : _pagos.last.id + 1,
      valor: valor,
      fecha: DateTime.now(),
      metodoPago: metodo,
      idCita: cita.id,
      idUsuario: cita.idCliente,
    );
    _pagos.add(pago);
    return pago;
  }
}
