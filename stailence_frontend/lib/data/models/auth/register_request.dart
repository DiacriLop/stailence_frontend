class RegisterRequest {
  const RegisterRequest({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.contrasena,
    required this.confirmarContrasena,
  });

  final String nombre;
  final String apellido;
  final String correo;
  final String contrasena;
  final String confirmarContrasena;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'contrasena': contrasena,
      'confirmarContrasena': confirmarContrasena,
    };
  }
}
