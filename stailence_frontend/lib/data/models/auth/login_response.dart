class LoginResponse {
  const LoginResponse({
    required this.accessToken,
    required this.nombre,
    required this.correo,
    required this.tokenType,
    this.apellido,
  });

  final String accessToken;
  final String nombre;
  final String correo;
  final String tokenType;
  final String? apellido;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      tokenType: (json['tokenType'] ?? 'Bearer') as String,
      apellido: json['apellido'] as String?,
    );
  }
}
