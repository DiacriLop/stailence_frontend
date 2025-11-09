// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empleado_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmpleadoModel _$EmpleadoModelFromJson(Map<String, dynamic> json) =>
    EmpleadoModel(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      especialidad: json['especialidad'] as String?,
      descripcion: json['descripcion'] as String?,
      activo: json['activo'] as bool? ?? true,
    );

Map<String, dynamic> _$EmpleadoModelToJson(EmpleadoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'fotoUrl': instance.fotoUrl,
      'especialidad': instance.especialidad,
      'descripcion': instance.descripcion,
      'activo': instance.activo,
    };
