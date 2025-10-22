enum CitaEstado { reservada, cancelada, completada, reprogramada }

class Cita {
  const Cita({
    required this.id,
    required this.fechaEstimada,
    required this.horaEstipulada,
    this.fechaReal,
    required this.estado,
    this.idEmpleado,
    this.idServicio,
    this.idCliente,
  });

  final int id;
  final DateTime fechaEstimada;
  final String horaEstipulada;
  final DateTime? fechaReal;
  final CitaEstado estado;
  final int? idEmpleado;
  final int? idServicio;
  final int? idCliente;
}
