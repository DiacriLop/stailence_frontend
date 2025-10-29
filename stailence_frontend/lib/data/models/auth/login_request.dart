class LoginRequest {
  const LoginRequest({required this.correo, required this.contrasena});

  final String correo;
  final String contrasena;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'correo': correo, 'contrasena': contrasena};
  }
}
