enum MetodoPago { efectivo, tarjeta, transferencia, otros }

class Pago {
  const Pago({
    required this.id,
    required this.valor,
    required this.fecha,
    required this.metodoPago,
    this.idCita,
    this.idUsuario,
  });

  final int id;
  final double valor;
  final DateTime fecha;
  final MetodoPago metodoPago;
  final int? idCita;
  final int? idUsuario;
}
