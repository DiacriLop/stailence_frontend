import '../../domain/entities/servicio.dart';

class ServicioModel extends Servicio {
  const ServicioModel({
    required super.id,
    required super.nombre,
    required super.duracion,
    required super.precio,
    super.idNegocio,
  });

  factory ServicioModel.fromJson(Map<String, dynamic> json) {
    return ServicioModel(
      id: json['id_Servicios'] as int,
      nombre: json['nombre_servicio'] as String,
      duracion: json['duracion_servicio'] as int,
      precio: double.parse(json['precio'].toString()),
      idNegocio: json['id_Negocio'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Servicios': id,
      'nombre_servicio': nombre,
      'duracion_servicio': duracion,
      'precio': precio,
      'id_Negocio': idNegocio,
    };
  }
}
