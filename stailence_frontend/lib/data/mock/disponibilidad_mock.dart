import '../../domain/entities/disponibilidad.dart';

class DisponibilidadMock {
  const DisponibilidadMock._();

  static List<Disponibilidad> build() {
    return const [
      Disponibilidad(
        id: 1,
        idEmpleado: 2,
        dia: DiaSemana.lunes,
        horaInicio: '09:00',
        horaFin: '17:00',
      ),
      Disponibilidad(
        id: 2,
        idEmpleado: 2,
        dia: DiaSemana.miercoles,
        horaInicio: '11:00',
        horaFin: '19:00',
      ),
      Disponibilidad(
        id: 3,
        idEmpleado: 3,
        dia: DiaSemana.martes,
        horaInicio: '08:00',
        horaFin: '16:00',
      ),
      Disponibilidad(
        id: 4,
        idEmpleado: 3,
        dia: DiaSemana.jueves,
        horaInicio: '10:00',
        horaFin: '18:00',
      ),
      Disponibilidad(
        id: 5,
        idEmpleado: 4,
        dia: DiaSemana.viernes,
        horaInicio: '12:00',
        horaFin: '20:00',
      ),
      Disponibilidad(
        id: 6,
        idEmpleado: 4,
        dia: DiaSemana.sabado,
        horaInicio: '09:00',
        horaFin: '15:00',
      ),
    ];
  }
}
