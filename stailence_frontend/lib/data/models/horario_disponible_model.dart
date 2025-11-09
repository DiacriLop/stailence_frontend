import 'package:json_annotation/json_annotation.dart';

part 'horario_disponible_model.g.dart';

@JsonSerializable()
class HorarioDisponibleModel {
  final String horaInicio;
  final String horaFin;
  final bool disponible;

  HorarioDisponibleModel({
    required this.horaInicio,
    required this.horaFin,
    this.disponible = true,
  });

  factory HorarioDisponibleModel.fromJson(Map<String, dynamic> json) =>
      _$HorarioDisponibleModelFromJson(json);

  Map<String, dynamic> toJson() => _$HorarioDisponibleModelToJson(this);
}
