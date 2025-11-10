import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/failures.dart';
import '../models/negocio_model.dart';

class NegocioService {
  NegocioService({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  /// Obtiene la lista de negocios desde el backend.
  /// Requiere el token de acceso (solo el token, sin el prefijo `Bearer`).
  Future<List<NegocioModel>> obtenerNegocios({required String token}) async {
    final Uri url = Uri.parse('$baseUrl${ApiEndpoints.negocios}');

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
      throw const NetworkFailure('Error de cliente HTTP al obtener negocios');
    }

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((json) => NegocioModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const ServerFailure('Unauthorized');
    }

    throw ServerFailure('Error al cargar los negocios (código ${response.statusCode}).');
  }

  Future<NegocioModel> obtenerNegocioPorId({required int id, required String token}) async {
    final Uri url = Uri.parse('$baseUrl${ApiEndpoints.negocios}/$id');

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
      throw const NetworkFailure('Error de cliente HTTP al obtener negocio');
    }

    if (response.statusCode == 200) {
      return NegocioModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw const ServerFailure('Unauthorized');
    }

    throw ServerFailure('Error al cargar el negocio (código ${response.statusCode}).');
  }
}
