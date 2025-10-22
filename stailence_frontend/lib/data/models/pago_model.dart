import '../../domain/entities/pago.dart';

class PagoModel extends Pago {
  const PagoModel({
    required super.id,
    required super.valor,
    required super.fecha,
    required super.metodoPago,
    super.idCita,
    super.idUsuario,
  });

  factory PagoModel.fromJson(Map<String, dynamic> json) {
    return PagoModel(
      id: json['id_Pagos'] as int,
      valor: double.parse(json['valor'].toString()),
      fecha: DateTime.parse(json['fecha'] as String),
      metodoPago: MetodoPago.values.byName(json['metodo_pago'] as String),
      idCita: json['id_Cita'] as int?,
      idUsuario: json['id_Usuario'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Pagos': id,
      'valor': valor,
      'fecha': fecha.toIso8601String(),
      'metodo_pago': metodoPago.name,
      'id_Cita': idCita,
      'id_Usuario': idUsuario,
    };
  }
}
