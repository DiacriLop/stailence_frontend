import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.id,
    required super.nombre,
    required super.apellido,
    required super.correo,
    required super.contrasena,
    required super.rol,
    super.idTipo,
    super.idNegocio,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id_Usuarios'] as int,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      correo: json['correo'] as String,
      contrasena: json['contrasena'] as String,
      rol: UsuarioRol.values.byName(json['rol'] as String),
      idTipo: json['id_Tipo'] as int?,
      idNegocio: json['id_Negocio'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_Usuarios': id,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'contrasena': contrasena,
      'rol': rol.name,
      'id_Tipo': idTipo,
      'id_Negocio': idNegocio,
    };
  }
}
