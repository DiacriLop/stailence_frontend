import '../../domain/entities/disponibilidad.dart';

class DisponibilidadMock {
  const DisponibilidadMock._();

  static List<Disponibilidad> build() {
    return const [
      Disponibilidad(
        id: 100,
        idEmpleado: 200,
        dia: DiaSemana.lunes,
        horaInicio: '09:00',
        horaFin: '17:00',
      ),
      Disponibilidad(
        id: 200,
        idEmpleado: 200,
        dia: DiaSemana.miercoles,
        horaInicio: '11:00',
        horaFin: '19:00',
      ),
      Disponibilidad(
        id: 300,
        idEmpleado: 300,
        dia: DiaSemana.martes,
        horaInicio: '08:00',
        horaFin: '16:00',
      ),
      Disponibilidad(
        id: 400,
        idEmpleado: 300,
        dia: DiaSemana.jueves,
        horaInicio: '10:00',
        horaFin: '18:00',
      ),
      Disponibilidad(
        id: 500,
        idEmpleado: 400,
        dia: DiaSemana.viernes,
        horaInicio: '12:00',
        horaFin: '20:00',
      ),
      Disponibilidad(
        id: 600,
        idEmpleado: 400,
        dia: DiaSemana.sabado,
        horaInicio: '09:00',
        horaFin: '15:00',
      ),
    ];
  }
}
