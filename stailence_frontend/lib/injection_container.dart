import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/auth_repository.dart';
import 'data/services/auth_service.dart';

class InjectionContainer {
  const InjectionContainer._();

  static late final AuthRepository authRepository;

  static Future<void> init() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final AuthService authService = AuthService();

    authRepository = AuthRepository(
      authService: authService,
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    );

    await authRepository.loadPersistedSession();
  }
}
