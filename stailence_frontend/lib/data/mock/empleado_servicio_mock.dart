import '../../domain/entities/empleado_servicio.dart';
import '../../domain/entities/empleado.dart';
import '../../domain/entities/servicio.dart';

class EmpleadoServicioMock {
  const EmpleadoServicioMock._();

  static List<EmpleadoServicio> build() {
    return <EmpleadoServicio>[
      // Restauramos algunos empleados mocks y sus asignaciones a servicios
      // para que la app muestre tanto datos reales como mocks.
      EmpleadoServicio(
        idEmpleado: 200,
        idServicio: 101,
        empleado: const Empleado(
          id: 200,
          nombre: 'Juan',
          apellido: 'Pérez',
          correo: 'juan@stailence.co',
        ),
        servicio: const Servicio(
          id: 101,
          nombre: 'Corte premium con lavado',
          duracion: 45,
          precio: 45000,
          idNegocio: 100,
        ),
      ),
      EmpleadoServicio(
        idEmpleado: 200,
        idServicio: 102,
        empleado: const Empleado(
          id: 200,
          nombre: 'Juan',
          apellido: 'Pérez',
          correo: 'juan@stailence.co',
        ),
        servicio: const Servicio(
          id: 102,
          nombre: 'Barba clásica con tratamiento',
          duracion: 40,
          precio: 38000,
          idNegocio: 100,
        ),
      ),
      EmpleadoServicio(
        idEmpleado: 200,
        idServicio: 103,
        empleado: const Empleado(
          id: 200,
          nombre: 'Juan',
          apellido: 'Pérez',
          correo: 'juan@stailence.co',
        ),
        servicio: const Servicio(
          id: 103,
          nombre: 'Paquete spa facial masculino',
          duracion: 60,
          precio: 65000,
          idNegocio: 100,
        ),
      ),

      EmpleadoServicio(
        idEmpleado: 300,
        idServicio: 201,
        empleado: const Empleado(
          id: 300,
          nombre: 'Laura',
          apellido: 'Gómez',
          correo: 'laura@stailence.co',
        ),
        servicio: const Servicio(
          id: 201,
          nombre: 'Coloración balayage',
          duracion: 120,
          precio: 180000,
          idNegocio: 200,
        ),
      ),
      EmpleadoServicio(
        idEmpleado: 300,
        idServicio: 202,
        empleado: const Empleado(
          id: 300,
          nombre: 'Laura',
          apellido: 'Gómez',
          correo: 'laura@stailence.co',
        ),
        servicio: const Servicio(
          id: 202,
          nombre: 'Peinado para eventos',
          duracion: 75,
          precio: 85000,
          idNegocio: 200,
        ),
      ),
      EmpleadoServicio(
        idEmpleado: 300,
        idServicio: 203,
        empleado: const Empleado(
          id: 300,
          nombre: 'Laura',
          apellido: 'Gómez',
          correo: 'laura@stailence.co',
        ),
        servicio: const Servicio(
          id: 203,
          nombre: 'Peinado para eventos',
          duracion: 50,
          precio: 90000,
          idNegocio: 200,
        ),
      ),

      EmpleadoServicio(
        idEmpleado: 400,
        idServicio: 301,
        empleado: const Empleado(
          id: 400,
          nombre: 'Carlos',
          apellido: 'Ríos',
          correo: 'carlos@stailence.co',
        ),
        servicio: const Servicio(
          id: 301,
          nombre: 'Masaje relajante',
          duracion: 60,
          precio: 90000,
          idNegocio: 300,
        ),
      ),
      EmpleadoServicio(
        idEmpleado: 400,
        idServicio: 302,
        empleado: const Empleado(
          id: 400,
          nombre: 'Carlos',
          apellido: 'Ríos',
          correo: 'carlos@stailence.co',
        ),
        servicio: const Servicio(
          id: 302,
          nombre: 'Spa de manos y pies',
          duracion: 50,
          precio: 70000,
          idNegocio: 300,
        ),
      ),
      EmpleadoServicio(
        idEmpleado: 400,
        idServicio: 303,
        empleado: const Empleado(
          id: 400,
          nombre: 'Carlos',
          apellido: 'Ríos',
          correo: 'carlos@stailence.co',
        ),
        servicio: const Servicio(
          id: 303,
          nombre: 'Limpieza facial profunda',
          duracion: 55,
          precio: 75000,
          idNegocio: 300,
        ),
      ),
      // Empleado adicional restaurado según API (correo: carlos.empleado@demo.com)
      /*EmpleadoServicio(
        idEmpleado: 400,
        idServicio: 202,
        empleado: const Empleado(
          id: 400,
          nombre: 'Carlos',
          apellido: 'Gómez',
          correo: 'carlos.empleado@demo.com',
        ),
        servicio: const Servicio(
          id: 202,
          nombre: 'Peinado para eventos',
          duracion: 75,
          precio: 85000,
          idNegocio: 200,
        ),
      ),*/
    ];
  }
}
