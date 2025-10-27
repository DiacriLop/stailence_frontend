import 'servicio.dart';

class Negocio {
  const Negocio({
    required this.id,
    required this.nombre,
    this.direccion,
    this.telefono,
    this.correo,
    this.horarioGeneral,
    this.serviciosDestacados,
    this.imageUrl,
  });

  final int id;
  final String nombre;
  final String? direccion;
  final String? telefono;
  final String? correo;
  final String? horarioGeneral;
  final List<Servicio>? serviciosDestacados;
  final String? imageUrl;
}
