import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/failures.dart';
import '../models/servicio_model.dart';
import '../models/empleado_model.dart';
import '../models/horario_disponible_model.dart';

class ServicioService {
  ServicioService({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<List<ServicioModel>> obtenerServicios() async {
    final response = await client.get(
      Uri.parse('$baseUrl${ApiEndpoints.servicios}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => ServicioModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw const ServerFailure('Error al cargar los servicios');
    }
  }

  Future<List<EmpleadoModel>> obtenerEmpleadosPorServicio(int servicioId) async {
    final response = await client.get(
      Uri.parse('$baseUrl${ApiEndpoints.servicios}/$servicioId/empleados'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => EmpleadoModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw const ServerFailure('Error al cargar los empleados');
    }
  }

  Future<List<HorarioDisponibleModel>> obtenerHorariosDisponibles({
    required int servicioId,
    required int empleadoId,
    required DateTime fecha,
  }) async {
    final response = await client.get(
      Uri.parse(
        '$baseUrl${ApiEndpoints.servicios}/$servicioId/empleados/$empleadoId/horarios?fecha=${fecha.toIso8601String().split('T')[0]}',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((json) => HorarioDisponibleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw const ServerFailure('Error al cargar los horarios disponibles');
    }
  }
}
