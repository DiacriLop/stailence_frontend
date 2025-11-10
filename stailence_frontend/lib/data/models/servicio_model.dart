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
    // The API may return the negocio id directly as 'id_Negocio' or as a nested
    // object under 'negocio' with key 'id' or 'id_Negocios'.
    int? parsedIdNegocio;
    if (json.containsKey('id_Negocio')) {
      parsedIdNegocio = json['id_Negocio'] as int?;
    } else if (json.containsKey('negocio') && json['negocio'] is Map) {
      final negocioObj = json['negocio'] as Map<String, dynamic>;
      // Try different possible key names for the negocio id
      parsedIdNegocio =
          negocioObj['id'] as int? ??
          negocioObj['id_Negocios'] as int? ??
          negocioObj['id_Negocio'] as int?;
    }

    // Parse field names: handle both snake_case and camelCase
    final int id = json['id_Servicios'] != null
        ? json['id_Servicios'] as int
        : json['id'] as int;

    final String nombre = json['nombre_servicio'] != null
        ? json['nombre_servicio'] as String
        : json['nombreServicio'] as String;

    final int duracion = json['duracion_servicio'] != null
        ? json['duracion_servicio'] as int
        : json['duracionServicio'] as int;

    final double precio = double.parse(json['precio'].toString());

    return ServicioModel(
      id: id,
      nombre: nombre,
      duracion: duracion,
      precio: precio,
      idNegocio: parsedIdNegocio,
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
