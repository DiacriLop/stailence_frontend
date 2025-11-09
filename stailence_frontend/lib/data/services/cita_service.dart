import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/failures.dart';
import '../models/cita_model.dart';

class CitaService {
  CitaService({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<List<CitaModel>> obtenerCitas(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl${ApiEndpoints.citas}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList.map((json) => CitaModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw const ServerFailure('Error al cargar las citas');
    }
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
      return CitaModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
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
