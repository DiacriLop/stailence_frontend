import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'application/app_state.dart';
import 'core/constants/api_endpoints.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/cita_repository.dart';
import 'data/repositories/servicio_repository.dart';
import 'data/repositories/usuario_repository.dart';
import 'data/services/auth_service.dart';
import 'data/services/cita_service.dart';
import 'data/services/servicio_service.dart';
import 'data/services/usuario_service.dart';
import 'application/cita_provider.dart';

final getIt = GetIt.instance;

class InjectionContainer {
  const InjectionContainer._();

  static Future<void> init() async {
    // External Dependencies
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final http.Client client = http.Client();

    // Services
    getIt.registerLazySingleton<AuthService>(
      () => AuthService(client: client),
    );
    
    getIt.registerLazySingleton<ServicioService>(
      () => ServicioService(client: client, baseUrl: ApiEndpoints.baseUrl),
    );
    
    getIt.registerLazySingleton<CitaService>(
      () => CitaService(client: client, baseUrl: ApiEndpoints.baseUrl),
    );
    
    getIt.registerLazySingleton<UsuarioService>(
      () => UsuarioService(client: client, baseUrl: ApiEndpoints.baseUrl),
    );

    // Repositories
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        authService: getIt<AuthService>(),
        secureStorage: secureStorage,
        sharedPreferences: sharedPreferences,
      ),
    );

    getIt.registerLazySingleton<ServicioRepository>(
      () => ServicioRepository(service: getIt<ServicioService>()),
    );

    getIt.registerLazySingleton<CitaRepository>(
      () => CitaRepository(service: getIt<CitaService>()),
    );

    getIt.registerLazySingleton<UsuarioRepository>(
      () => UsuarioRepository(service: getIt<UsuarioService>()),
    );

    // App State
    getIt.registerLazySingleton<AppState>(
      () => AppState(
        authRepository: getIt<AuthRepository>(),
      ),
    );

    // Providers
    getIt.registerFactory<CitaProvider>(
      () => CitaProvider(
        citaRepository: getIt<CitaRepository>(),
        authRepository: getIt<AuthRepository>(),
      ),
    );

    // Load persisted session
    await getIt<AuthRepository>().loadPersistedSession();
  }
}
