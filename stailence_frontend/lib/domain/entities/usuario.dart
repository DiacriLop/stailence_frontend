enum UsuarioRol { cliente, empleado, administrador }

class Usuario {
  const Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.contrasena,
    required this.rol,
    this.idTipo,
    this.idNegocio,
  });

  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String contrasena;
  final UsuarioRol rol;
  final int? idTipo;
  final int? idNegocio;
}
