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
    int? _readInt(List<String> keys, {int? defaultValue}) {
      for (final String key in keys) {
        final Object? value = json[key];
        if (value is int) {
          return value;
        }
        if (value is String) {
          final int? parsed = int.tryParse(value);
          if (parsed != null) {
            return parsed;
          }
        }
      }
      return defaultValue;
    }

    UsuarioRol _readRole() {
      final Object? value = json['rol'] ?? json['rolUsuario'];
      if (value is String) {
        final String normalized = value.toLowerCase();
        for (final UsuarioRol rol in UsuarioRol.values) {
          if (rol.name.toLowerCase() == normalized) {
            return rol;
          }
        }
      }
      return UsuarioRol.cliente;
    }

    final int id = _readInt(<String>['id', 'idUsuario', 'id_Usuarios']) ?? -1;
    final int? idTipo = _readInt(<String>['idTipo', 'id_Tipo']);
    final int? idNegocio = _readInt(<String>['idNegocio', 'id_Negocio']);

    return UsuarioModel(
      id: id,
      nombre: (json['nombre'] ?? json['firstName']) as String? ?? '',
      apellido: (json['apellido'] ?? json['lastName']) as String? ?? '',
      correo: (json['correo'] ?? json['email']) as String? ?? '',
      contrasena: json['contrasena'] as String? ?? '',
      rol: _readRole(),
      idTipo: idTipo,
      idNegocio: idNegocio,
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
