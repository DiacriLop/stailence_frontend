import '../../domain/entities/negocio.dart';
import '../../domain/entities/servicio.dart';
import 'servicio_model.dart';

class NegocioModel extends Negocio {
  const NegocioModel({
    required super.id,
    required super.nombre,
    super.direccion,
    super.telefono,
    super.correo,
    super.horarioGeneral,
    super.serviciosDestacados,
    super.imageUrl,
  });

  factory NegocioModel.fromJson(Map<String, dynamic> json) {
    return NegocioModel(
      id: json['id_Negocios'] as int,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String?,
      telefono: json['telefono'] as String?,
      correo: json['correo'] as String?,
      horarioGeneral: json['horario_general'] as String?,
      serviciosDestacados: (json['servicios_destacados'] as List<dynamic>?)
          ?.map((dynamic item) {
        if (item is Servicio) {
          return item;
        }
        if (item is Map<String, dynamic>) {
          return ServicioModel.fromJson(item);
        }
        throw ArgumentError('Formato de servicio no soportado: $item');
      }).toList(),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Negocios': id,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
      'horario_general': horarioGeneral,
      'servicios_destacados': serviciosDestacados?.map((Servicio servicio) =>
          servicio is ServicioModel ? servicio.toJson() : ServicioModel(
                id: servicio.id,
                nombre: servicio.nombre,
                duracion: servicio.duracion,
                precio: servicio.precio,
                idNegocio: servicio.idNegocio,
              ).toJson()).toList(),
      'image_url': imageUrl,
    };
  }
}
