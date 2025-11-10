import 'dart:convert';
import 'dart:io';

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

  Future<List<ServicioModel>> obtenerServicios({required String token}) async {
    final Uri url = Uri.parse('$baseUrl${ApiEndpoints.servicios}');

    final http.Response response;
    try {
      response = await client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } on SocketException catch (_) {
      throw const NetworkFailure('No se pudo conectar con el servidor');
    } on http.ClientException catch (_) {
      throw const NetworkFailure('Error de cliente HTTP al obtener servicios');
    }

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      List<dynamic> jsonList = <dynamic>[];
      if (decoded == null) {
        jsonList = <dynamic>[];
      } else if (decoded is List) {
        jsonList = decoded;
      } else if (decoded is Map) {
        if (decoded.containsKey('content')) {
          jsonList = decoded['content'] as List<dynamic>;
        } else if (decoded.containsKey('data')) {
          jsonList = decoded['data'] as List<dynamic>;
        } else {
          // single object returned, wrap into list
          jsonList = [decoded];
        }
      } else {
        throw const ServerFailure('Respuesta inesperada al obtener servicios');
      }

      return jsonList
          .map((json) => ServicioModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const ServerFailure('Unauthorized');
    }

    throw ServerFailure(
      'Error al cargar los servicios (código ${response.statusCode}).',
    );
  }

  Future<List<EmpleadoModel>> obtenerEmpleadosPorServicio(
    int servicioId, {
    required String token,
  }) async {
    final Uri url = Uri.parse(
      '$baseUrl${ApiEndpoints.servicios}/$servicioId/empleados',
    );

    final http.Response response;
    try {
      response = await client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } on SocketException catch (_) {
      throw const NetworkFailure('No se pudo conectar con el servidor');
    } on http.ClientException catch (_) {
      throw const NetworkFailure('Error de cliente HTTP al obtener empleados');
    }

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((json) => EmpleadoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const ServerFailure('Unauthorized');
    }

    throw ServerFailure(
      'Error al cargar los empleados (código ${response.statusCode}).',
    );
  }

  Future<List<HorarioDisponibleModel>> obtenerHorariosDisponibles({
    required int servicioId,
    required int empleadoId,
    required DateTime fecha,
    required String token,
  }) async {
    final Uri url = Uri.parse(
      '$baseUrl${ApiEndpoints.servicios}/$servicioId/empleados/$empleadoId/horarios?fecha=${fecha.toIso8601String().split('T')[0]}',
    );

    final http.Response response;
    try {
      response = await client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } on SocketException catch (_) {
      throw const NetworkFailure('No se pudo conectar con el servidor');
    } on http.ClientException catch (_) {
      throw const NetworkFailure('Error de cliente HTTP al obtener horarios');
    }

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map(
            (json) =>
                HorarioDisponibleModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const ServerFailure('Unauthorized');
    }

    throw ServerFailure(
      'Error al cargar los horarios disponibles (código ${response.statusCode}).',
    );
  }
}
