import '../../domain/entities/empleado_servicio.dart';

class EmpleadoServicioMock {
  const EmpleadoServicioMock._();

  static List<EmpleadoServicio> build() {
    return const [
      EmpleadoServicio(idEmpleado: 2, idServicio: 101),
      EmpleadoServicio(idEmpleado: 2, idServicio: 102),
      EmpleadoServicio(idEmpleado: 2, idServicio: 103),
      EmpleadoServicio(idEmpleado: 3, idServicio: 201),
      EmpleadoServicio(idEmpleado: 3, idServicio: 202),
      EmpleadoServicio(idEmpleado: 3, idServicio: 203),
      EmpleadoServicio(idEmpleado: 4, idServicio: 301),
      EmpleadoServicio(idEmpleado: 4, idServicio: 302),
      EmpleadoServicio(idEmpleado: 4, idServicio: 303),
    ];
  }
}
