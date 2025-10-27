enum DiaSemana { lunes, martes, miercoles, jueves, viernes, sabado, domingo }

class Disponibilidad {
  const Disponibilidad({
    required this.id,
    required this.idEmpleado,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
  });

  final int id;
  final int? idEmpleado;
  final DiaSemana dia;
  final String horaInicio;
  final String horaFin;
}
