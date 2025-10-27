import '../../domain/entities/usuario.dart';

class UsuariosMock {
  const UsuariosMock._();

  static List<Usuario> build() {
    return [
      const Usuario(
        id: 1,
        nombre: 'Daniela',
        apellido: 'Fernández',
        correo: 'daniela@email.com',
        contrasena: '123456',
        rol: UsuarioRol.cliente,
      ),
      const Usuario(
        id: 2,
        nombre: 'Juan',
        apellido: 'Pérez',
        correo: 'juan@stailence.co',
        contrasena: 'barber1',
        rol: UsuarioRol.empleado,
        idNegocio: 1,
      ),
      const Usuario(
        id: 3,
        nombre: 'Laura',
        apellido: 'Gómez',
        correo: 'laura@stailence.co',
        contrasena: 'stylist',
        rol: UsuarioRol.empleado,
        idNegocio: 2,
      ),
      const Usuario(
        id: 4,
        nombre: 'Carlos',
        apellido: 'Ríos',
        correo: 'carlos@stailence.co',
        contrasena: 'spa123',
        rol: UsuarioRol.empleado,
        idNegocio: 3,
      ),
    ];
  }
}
