import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/failures.dart';
import '../models/cita_model.dart';

class CitaService {
  CitaService({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<List<CitaModel>> obtenerCitas({required String token}) async {
    final Uri url = Uri.parse('$baseUrl${ApiEndpoints.citas}');

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
      throw const NetworkFailure('Error de cliente HTTP al obtener citas');
    }

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      List<dynamic> jsonList = <dynamic>[];

      if (decoded == null) {
        jsonList = <dynamic>[];
      } else if (decoded is List) {
        jsonList = decoded;
      } else if (decoded is Map) {
        // Handle nested structures: content, data, or single object
        if (decoded.containsKey('content')) {
          jsonList = decoded['content'] as List<dynamic>;
        } else if (decoded.containsKey('data')) {
          jsonList = decoded['data'] as List<dynamic>;
        } else {
          // Single object returned, wrap into list
          jsonList = [decoded];
        }
      } else {
        throw const ServerFailure('Respuesta inesperada al obtener citas');
      }

      return jsonList
          .map((json) => CitaModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const ServerFailure('Unauthorized');
    }

    throw ServerFailure(
      'Error al cargar las citas (código ${response.statusCode}).',
    );
  }

  Future<CitaModel> crearCita({
    required String token,
    required int servicioId,
    required DateTime fecha,
    required String hora,
    required int empleadoId,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl${ApiEndpoints.citas}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'servicioId': servicioId,
        'fecha': fecha.toIso8601String().split('T')[0],
        'hora': hora,
        'empleadoId': empleadoId,
      }),
    );

    if (response.statusCode == 201) {
      return CitaModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw const ServerFailure('Error al crear la cita');
    }
  }

  Future<void> cancelarCita(String token, int citaId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl${ApiEndpoints.citas}/$citaId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw const ServerFailure('Error al cancelar la cita');
    }
  }
}
