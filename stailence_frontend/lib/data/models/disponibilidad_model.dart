import '../../domain/entities/disponibilidad.dart';

class DisponibilidadModel extends Disponibilidad {
  const DisponibilidadModel({
    required super.id,
    required super.idEmpleado,
    required super.dia,
    required super.horaInicio,
    required super.horaFin,
  });

  factory DisponibilidadModel.fromJson(Map<String, dynamic> json) {
    final diaValue = (json['dia'] as String).toLowerCase();
    final dia = DiaSemana.values.firstWhere((element) => element.name == diaValue);
    return DisponibilidadModel(
      id: json['id_Disponibilidad'] as int,
      idEmpleado: json['id_Empleado'] as int?,
      dia: dia,
      horaInicio: json['hora_inicio'] as String,
      horaFin: json['hora_fin'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Disponibilidad': id,
      'id_Empleado': idEmpleado,
      'dia': dia.name,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
    };
  }
}
