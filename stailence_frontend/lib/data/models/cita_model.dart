import '../../domain/entities/cita.dart';

class CitaModel extends Cita {
  const CitaModel({
    required super.id,
    required super.fechaEstimada,
    required super.horaEstipulada,
    super.fechaReal,
    required super.estado,
    super.idEmpleado,
    super.idServicio,
    super.idCliente,
  });

  factory CitaModel.fromJson(Map<String, dynamic> json) {
    // Parse field names: handle both snake_case and camelCase
    final int id = json['id_Citas'] != null
        ? json['id_Citas'] as int
        : json['id'] as int;

    final DateTime fechaEstimada = json['fecha_estimada'] != null
        ? DateTime.parse(json['fecha_estimada'] as String)
        : DateTime.parse(json['fechaEstimada'] as String);

    final String horaEstipulada = json['hora_estipulada'] != null
        ? json['hora_estipulada'] as String
        : json['horaEstipulada'] as String;

    final DateTime? fechaReal = json['fecha_real'] != null
        ? DateTime.parse(json['fecha_real'] as String)
        : (json['fechaReal'] != null
              ? DateTime.parse(json['fechaReal'] as String)
              : null);

    // Parse estado: handle both lowercase string and enum
    final String estadoStr = json['estado'] as String;
    final CitaEstado estado = CitaEstado.values.firstWhere(
      (CitaEstado e) => e.name == estadoStr.toLowerCase(),
      orElse: () => CitaEstado.reservada,
    );

    // Extract id from nested objects if present
    int? idEmpleado = json['id_Empleado'] as int? ?? json['idEmpleado'] as int?;
    if (idEmpleado == null && json['empleado'] is Map) {
      final empleadoObj = json['empleado'] as Map<String, dynamic>;
      idEmpleado = empleadoObj['id'] as int?;
    }

    int? idServicio = json['id_Servicio'] as int? ?? json['idServicio'] as int?;
    if (idServicio == null && json['servicio'] is Map) {
      final servicioObj = json['servicio'] as Map<String, dynamic>;
      idServicio = servicioObj['id'] as int?;
    }

    int? idCliente = json['id_Cliente'] as int? ?? json['idCliente'] as int?;
    if (idCliente == null && json['cliente'] is Map) {
      final clienteObj = json['cliente'] as Map<String, dynamic>;
      idCliente = clienteObj['id'] as int?;
    }

    return CitaModel(
      id: id,
      fechaEstimada: fechaEstimada,
      horaEstipulada: horaEstipulada,
      fechaReal: fechaReal,
      estado: estado,
      idEmpleado: idEmpleado,
      idServicio: idServicio,
      idCliente: idCliente,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Citas': id,
      'fecha_estimada': fechaEstimada.toIso8601String(),
      'hora_estipulada': horaEstipulada,
      'fecha_real': fechaReal?.toIso8601String(),
      'estado': estado.name,
      'id_Empleado': idEmpleado,
      'id_Servicio': idServicio,
      'id_Cliente': idCliente,
    };
  }
}
