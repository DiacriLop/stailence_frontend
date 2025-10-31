// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'horario_disponible_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HorarioDisponibleModel _$HorarioDisponibleModelFromJson(
  Map<String, dynamic> json,
) => HorarioDisponibleModel(
  horaInicio: json['horaInicio'] as String,
  horaFin: json['horaFin'] as String,
  disponible: json['disponible'] as bool? ?? true,
);

Map<String, dynamic> _$HorarioDisponibleModelToJson(
  HorarioDisponibleModel instance,
) => <String, dynamic>{
  'horaInicio': instance.horaInicio,
  'horaFin': instance.horaFin,
  'disponible': instance.disponible,
};
