import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/exceptions/failures.dart';
import '../models/empleado_servicio_model.dart';

class EmpleadoServicioService {
  EmpleadoServicioService({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<List<EmpleadoServicioModel>> obtenerEmpleadosPorServicio({
    required int servicioId,
    required String token,
  }) async {
    final Uri url = Uri.parse(
      '$baseUrl/api/empleado-servicio/servicio/$servicioId',
    );

    // Debug: show constructed URL and token presence
    try {
      // avoid printing full token, just whether it's present
      print('[EmpleadoServicioService] GET $url');
      print('[EmpleadoServicioService] token present: ${token.isNotEmpty}');
    } catch (_) {}

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
      throw const NetworkFailure(
        'Error de cliente HTTP al obtener empleados del servicio',
      );
    }

    if (response.statusCode == 200) {
      // Debug: log status and body
      try {
        print('[EmpleadoServicioService] status: ${response.statusCode}');
        print('[EmpleadoServicioService] body: ${response.body}');
      } catch (_) {}
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
        throw const ServerFailure(
          'Respuesta inesperada al obtener empleados del servicio',
        );
      }

      return jsonList
          .map(
            (json) =>
                EmpleadoServicioModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      print('[EmpleadoServicioService] unauthorized ${response.statusCode}');
      throw const ServerFailure('Unauthorized');
    }

    // Debug: other status codes
    print('[EmpleadoServicioService] unexpected status ${response.statusCode}');

    throw ServerFailure(
      'Error al cargar empleados del servicio (código ${response.statusCode}).',
    );
  }
}
