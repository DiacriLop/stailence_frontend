import '../../domain/entities/servicio.dart';

class ServiciosMock {
  const ServiciosMock._();

  static List<Servicio> build() {
    return const [
      Servicio(
        id: 101,
        nombre: 'Corte premium con lavado',
        duracion: 45,
        precio: 45000,
        idNegocio: 100,
        categoria: 'Cortes',
      ),
      Servicio(
        id: 102,
        nombre: 'Barba clásica con tratamiento',
        duracion: 40,
        precio: 38000,
        idNegocio: 100,
        categoria: 'Barbería',
      ),
      Servicio(
        id: 103,
        nombre: 'Paquete spa facial masculino',
        duracion: 60,
        precio: 65000,
        idNegocio: 100,
        categoria: 'Spa',
      ),
      Servicio(
        id: 201,
        nombre: 'Coloración balayage',
        duracion: 120,
        precio: 180000,
        idNegocio: 200,
        categoria: 'Coloración',
      ),
      Servicio(
        id: 202,
        nombre: 'Peinado para eventos',
        duracion: 75,
        precio: 85000,
        idNegocio: 200,
        categoria: 'Peinados',
      ),
      Servicio(
        id: 203,
        nombre: 'Tratamiento capilar nutritivo',
        duracion: 50,
        precio: 90000,
        idNegocio: 200,
        categoria: 'Tratamientos',
      ),
      Servicio(
        id: 301,
        nombre: 'Masaje relajante',
        duracion: 60,
        precio: 90000,
        idNegocio: 300,
        categoria: 'Spa',
      ),
      Servicio(
        id: 302,
        nombre: 'Spa de manos y pies',
        duracion: 50,
        precio: 70000,
        idNegocio: 300,
        categoria: 'Spa',
      ),
      Servicio(
        id: 303,
        nombre: 'Limpieza facial profunda',
        duracion: 55,
        precio: 75000,
        idNegocio: 300,
        categoria: 'Tratamientos',
      ),
    ];
  }
}
