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
    return CitaModel(
      id: json['id_Citas'] as int,
      fechaEstimada: DateTime.parse(json['fecha_estimada'] as String),
      horaEstipulada: json['hora_estipulada'] as String,
      fechaReal: json['fecha_real'] != null
          ? DateTime.parse(json['fecha_real'] as String)
          : null,
      estado: CitaEstado.values.byName(json['estado'] as String),
      idEmpleado: json['id_Empleado'] as int?,
      idServicio: json['id_Servicio'] as int?,
      idCliente: json['id_Cliente'] as int?,
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
