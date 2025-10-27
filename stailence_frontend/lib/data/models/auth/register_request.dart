class RegisterRequest {
  const RegisterRequest({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.contrasena,
  });

  final String nombre;
  final String apellido;
  final String correo;
  final String contrasena;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'contrasena': contrasena,
    };
  }
}
