import '../../domain/entities/notificacion.dart';

class NotificacionModel extends Notificacion {
  const NotificacionModel({
    required super.id,
    required super.mensajeRecordatorio,
    required super.fecha,
    required super.estado,
    super.idUsuario,
    super.idCita,
  });

  factory NotificacionModel.fromJson(Map<String, dynamic> json) {
    return NotificacionModel(
      id: json['id_Notificaciones'] as int,
      mensajeRecordatorio: json['mensaje_recordatorio'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      estado: EstadoNotificacion.values.byName(json['estado_notificacion'] as String),
      idUsuario: json['id_Usuario'] as int?,
      idCita: json['id_Cita'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Notificaciones': id,
      'mensaje_recordatorio': mensajeRecordatorio,
      'fecha': fecha.toIso8601String(),
      'estado_notificacion': estado.name,
      'id_Usuario': idUsuario,
      'id_Cita': idCita,
    };
  }
}
