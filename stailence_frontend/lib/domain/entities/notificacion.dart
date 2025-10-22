enum EstadoNotificacion { pendiente, enviada, vista }

class Notificacion {
  const Notificacion({
    required this.id,
    required this.mensajeRecordatorio,
    required this.fecha,
    required this.estado,
    this.idUsuario,
    this.idCita,
  });

  final int id;
  final String mensajeRecordatorio;
  final DateTime fecha;
  final EstadoNotificacion estado;
  final int? idUsuario;
  final int? idCita;
}
