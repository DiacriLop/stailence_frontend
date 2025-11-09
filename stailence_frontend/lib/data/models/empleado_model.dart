import 'package:json_annotation/json_annotation.dart';

part 'empleado_model.g.dart';

@JsonSerializable()
class EmpleadoModel {
  final int id;
  final String nombre;
  final String apellido;
  final String? fotoUrl;
  final String? especialidad;
  final String? descripcion;
  final bool activo;

  EmpleadoModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    this.fotoUrl,
    this.especialidad,
    this.descripcion,
    this.activo = true,
  });

  factory EmpleadoModel.fromJson(Map<String, dynamic> json) =>
      _$EmpleadoModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmpleadoModelToJson(this);
}
