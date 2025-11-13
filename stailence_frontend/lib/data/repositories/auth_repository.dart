import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/exceptions/failures.dart';
import '../../domain/entities/usuario.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../models/auth/register_request.dart';
import '../models/usuario_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository({
    required AuthService authService,
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  }) : _authService = authService,
       _secureStorage = secureStorage,
       _sharedPreferences = sharedPreferences;

  final AuthService _authService;
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  LoginResponse? _cachedSession;
  Usuario? _cachedUser;

  bool get hasValidSession => _cachedSession != null;
  Usuario? get currentUser => _cachedUser;

  Future<void> loadPersistedSession() async {
    final String? token = await _secureStorage.read(key: StorageKeys.token);
    final String? tokenType = await _secureStorage.read(
      key: StorageKeys.tokenType,
    );
    final String? nombre = _sharedPreferences.getString(StorageKeys.userName);
    final String? correo = _sharedPreferences.getString(StorageKeys.userEmail);
    final String? apellido = _sharedPreferences.getString(
      StorageKeys.userLastName,
    );

    if (token != null &&
        tokenType != null &&
        nombre != null &&
        correo != null) {
      _cachedSession = LoginResponse(
        accessToken: token,
        tokenType: tokenType,
        nombre: nombre,
        correo: correo,
        // apellido opcional
      );
      _cachedUser = Usuario(
        id: -1,
        nombre: nombre,
        apellido: apellido ?? '',
        correo: correo,
        contrasena: '',
        rol: UsuarioRol.cliente,
      );
    }
  }

  Future<Usuario> login({
    required String correo,
    required String contrasena,
  }) async {
    final LoginResponse response = await _authService.login(
      LoginRequest(correo: correo, contrasena: contrasena),
    );

    await Future.wait<void>(<Future<void>>[
      _secureStorage.write(key: StorageKeys.token, value: response.accessToken),
      _secureStorage.write(
        key: StorageKeys.tokenType,
        value: response.tokenType,
      ),
      _sharedPreferences.setString(StorageKeys.userName, response.nombre),
      _sharedPreferences.setString(StorageKeys.userEmail, response.correo),
      if (response.apellido != null)
        _sharedPreferences.setString(
          StorageKeys.userLastName,
          response.apellido!,
        ),
    ]);

    final String? apellidoPersisted =
        response.apellido ??
        _sharedPreferences.getString(StorageKeys.userLastName);

    _cachedSession = response;
    _cachedUser = Usuario(
      id: -1,
      nombre: response.nombre,
      apellido: apellidoPersisted ?? '',
      correo: response.correo,
      contrasena: '',
      rol: UsuarioRol.cliente,
    );

    return _cachedUser!;
  }

  Future<Usuario> register({
    required String nombre,
    required String apellido,
    required String correo,
    required String contrasena,
    required String confirmarContrasena,
  }) async {
    final UsuarioModel user = await _authService.register(
      RegisterRequest(
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        contrasena: contrasena,
        confirmarContrasena: confirmarContrasena,
      ),
    );

    _cachedUser = user;
    if (user.apellido.isNotEmpty) {
      await _sharedPreferences.setString(
        StorageKeys.userLastName,
        user.apellido,
      );
    }
    _cachedSession = LoginResponse(
      accessToken: '',
      tokenType: 'Bearer',
      nombre: user.nombre,
      correo: user.correo,
    );
    return _cachedUser!;
  }

  String? get token => _cachedSession?.accessToken;
  String? get tokenType => _cachedSession?.tokenType;

  Future<void> logout() async {
    _cachedSession = null;
    _cachedUser = null;
    await Future.wait<void>(<Future<void>>[
      _secureStorage.delete(key: StorageKeys.token),
      _secureStorage.delete(key: StorageKeys.tokenType),
      _sharedPreferences.remove(StorageKeys.userName),
      _sharedPreferences.remove(StorageKeys.userEmail),
      _sharedPreferences.remove(StorageKeys.userLastName),
    ]);
  }

  Map<String, String> buildAuthHeaders() {
    final String? token = _cachedSession?.accessToken;
    final String? tokenType = _cachedSession?.tokenType ?? 'Bearer';
    if (token == null) {
      throw const CacheFailure('No hay token almacenado.');
    }
    return <String, String>{
      'Authorization': '$tokenType $token',
      'Accept': 'application/json',
    };
  }
}
