import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/failures.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/register_request.dart';
import '../models/usuario_model.dart';

class AuthService {
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<LoginResponse> login(LoginRequest request) async {
    final Uri url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}');

    final http.Response response;
    try {
      response = await _client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );
    } on SocketException catch (_) {
      throw const NetworkFailure('No se pudo conectar con el servidor');
    } on http.ClientException catch (_) {
      throw const NetworkFailure('Error de cliente HTTP al iniciar sesión');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(body);
    }

    if (response.statusCode == 401) {
      throw const ServerFailure('Credenciales inválidas');
    }

    throw ServerFailure('No se pudo iniciar sesión (código ${response.statusCode}).');
  }

  Future<UsuarioModel> register(RegisterRequest request) async {
    final Uri url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.register}');

    final http.Response response;
    try {
      response = await _client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );
    } on SocketException catch (_) {
      throw const NetworkFailure('No se pudo conectar con el servidor');
    } on http.ClientException catch (_) {
      throw const NetworkFailure('Error de cliente HTTP al registrar');
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
      return UsuarioModel.fromJson(body);
    }

    if (response.statusCode == 400 || response.statusCode == 409) {
      final Map<String, dynamic>? body = response.body.isNotEmpty
          ? jsonDecode(response.body) as Map<String, dynamic>?
          : null;
      final String message = (body?['mensaje'] ?? 'No se pudo registrar el usuario') as String;
      throw ServerFailure(message);
    }

    throw ServerFailure('Error al registrar usuario (código ${response.statusCode}).');
  }
}
