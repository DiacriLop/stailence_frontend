import '../../core/exceptions/failures.dart';
import '../../data/models/negocio_model.dart';
import '../services/negocio_service.dart';
import 'auth_repository.dart';

class NegocioRepository {
  NegocioRepository({required this.service, required this.authRepository});

  final NegocioService service;
  final AuthRepository authRepository;

  Future<List<NegocioModel>> obtenerNegocios() async {
    try {
      final String? token = authRepository.token;
      if (token == null || token.isEmpty) {
        throw const CacheFailure('No hay sesión activa');
      }
      return await service.obtenerNegocios(token: token);
    } on ServerFailure catch (e) {
      // Si el servidor responde con 401/403, forzamos logout para re-login
      if (e.message.toLowerCase().contains('unauthorized') ||
          e.message.contains('401') ||
          e.message.contains('403')) {
        await authRepository.logout();
        throw const CacheFailure(
          'Sesión expirada. Por favor, inicia sesión de nuevo.',
        );
      }
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar los negocios');
    }
  }

  Future<NegocioModel> obtenerNegocioPorId(int id) async {
    try {
      final String? token = authRepository.token;
      if (token == null || token.isEmpty) {
        throw const CacheFailure('No hay sesión activa');
      }
      return await service.obtenerNegocioPorId(id: id, token: token);
    } on ServerFailure catch (e) {
      if (e.message.toLowerCase().contains('unauthorized') ||
          e.message.contains('401') ||
          e.message.contains('403')) {
        await authRepository.logout();
        throw const CacheFailure(
          'Sesión expirada. Por favor, inicia sesión de nuevo.',
        );
      }
      rethrow;
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Error al cargar el negocio');
    }
  }
}
