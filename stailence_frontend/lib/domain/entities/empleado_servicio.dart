import 'empleado.dart';
import 'servicio.dart';

class EmpleadoServicio {
  const EmpleadoServicio({
    required this.idEmpleado,
    required this.idServicio,
    required this.empleado,
    required this.servicio,
  });

  final int idEmpleado;
  final int idServicio;
  final Empleado empleado;
  final Servicio servicio;
}
