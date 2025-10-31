import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';
import '../../core/exceptions/failures.dart';
import '../models/usuario_model.dart';

class UsuarioService {
  UsuarioService({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<UsuarioModel> getPerfil(String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl${ApiEndpoints.usuarios}/perfil'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UsuarioModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw const ServerFailure('Error al cargar el perfil');
    }
  }

  Future<UsuarioModel> actualizarPerfil({
    required String token,
    required String nombre,
    required String apellido,
    required String correo,
  }) async {
    final response = await client.put(
      Uri.parse('$baseUrl${ApiEndpoints.usuarios}/perfil'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': nombre,
        'apellido': apellido,
        'correo': correo,
      }),
    );

    if (response.statusCode == 200) {
      return UsuarioModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw const ServerFailure('Error al actualizar el perfil');
    }
  }
}
