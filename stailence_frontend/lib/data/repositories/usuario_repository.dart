import '../../core/exceptions/failures.dart';
import '../models/usuario_model.dart';
import '../services/usuario_service.dart';

class UsuarioRepository {
  UsuarioRepository({required this.service});

  final UsuarioService service;

  Future<UsuarioModel> getPerfil(String token) async {
    try {
      return await service.getPerfil(token);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar el perfil');
    }
  }

  Future<UsuarioModel> actualizarPerfil({
    required String token,
    required String nombre,
    required String apellido,
    required String correo,
  }) async {
    try {
      return await service.actualizarPerfil(
        token: token,
        nombre: nombre,
        apellido: apellido,
        correo: correo,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al actualizar el perfil');
    }
  }
}
