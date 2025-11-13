import '../../domain/entities/empleado_servicio.dart';
import '../../domain/entities/empleado.dart';
import '../../domain/entities/servicio.dart';
import 'servicio_model.dart';

class EmpleadoServicioModel extends EmpleadoServicio {
  const EmpleadoServicioModel({
    required super.idEmpleado,
    required super.idServicio,
    required super.empleado,
    required super.servicio,
  });

  factory EmpleadoServicioModel.fromJson(Map<String, dynamic> json) {
    try {
      print('[EmpleadoServicioModel] fromJson input: ${json}');
    } catch (_) {}
    // Parse empleado (nested object or top-level fields)
    late final Empleado empleado;
    if (json.containsKey('empleado') && json['empleado'] is Map) {
      final empleadoMap = json['empleado'] as Map<String, dynamic>;
      empleado = _parseEmpleado(empleadoMap);
    } else {
      empleado = _parseEmpleado(json);
    }

    // Parse servicio (nested object or top-level fields)
    late final Servicio servicio;
    if (json.containsKey('servicio') && json['servicio'] is Map) {
      final servicioMap = json['servicio'] as Map<String, dynamic>;
      servicio = ServicioModel.fromJson(servicioMap);
    } else {
      servicio = ServicioModel.fromJson(json);
    }

    // Parse ids
    // The API sometimes returns an 'id' object with nested keys, e.g.:
    // "id": { "id_Empleado": 2, "id_Servicio": 2 }
    int idEmpleado = empleado.id;
    int idServicio = servicio.id;

    // direct fields (camelCase / snake_case)
    if (json['idEmpleado'] != null) {
      idEmpleado = json['idEmpleado'] as int;
    } else if (json['id_Empleado'] != null) {
      idEmpleado = json['id_Empleado'] as int;
    }

    if (json['idServicio'] != null) {
      idServicio = json['idServicio'] as int;
    } else if (json['id_Servicio'] != null) {
      idServicio = json['id_Servicio'] as int;
    }

    // nested id object
    if (json['id'] != null && json['id'] is Map) {
      final Map<String, dynamic> idMap = Map<String, dynamic>.from(
        json['id'] as Map,
      );
      if (idMap['id_Empleado'] != null) {
        idEmpleado = idMap['id_Empleado'] as int;
      } else if (idMap['idEmpleado'] != null) {
        idEmpleado = idMap['idEmpleado'] as int;
      }

      if (idMap['id_Servicio'] != null) {
        idServicio = idMap['id_Servicio'] as int;
      } else if (idMap['idServicio'] != null) {
        idServicio = idMap['idServicio'] as int;
      }
    }

    return EmpleadoServicioModel(
      idEmpleado: idEmpleado,
      idServicio: idServicio,
      empleado: empleado,
      servicio: servicio,
    );
  }

  static Empleado _parseEmpleado(Map<String, dynamic> json) {
    final int id = json['idUsuario'] != null
        ? json['idUsuario'] as int
        : json['id'] != null
        ? json['id'] as int
        : -1;

    final String nombre = (json['nombre'] ?? '') as String;
    final String apellido = (json['apellido'] ?? '') as String;
    final String correo = (json['correo'] ?? '') as String;

    return Empleado(id: id, nombre: nombre, apellido: apellido, correo: correo);
  }

  Map<String, dynamic> toJson() {
    return {
      'idEmpleado': idEmpleado,
      'idServicio': idServicio,
      'empleado': {
        'idUsuario': empleado.id,
        'nombre': empleado.nombre,
        'apellido': empleado.apellido,
        'correo': empleado.correo,
      },
      'servicio': {
        'id': servicio.id,
        'nombreServicio': servicio.nombre,
        'duracionServicio': servicio.duracion,
        'precio': servicio.precio,
      },
    };
  }
}
