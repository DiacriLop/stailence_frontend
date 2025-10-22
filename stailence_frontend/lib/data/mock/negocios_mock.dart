import '../../domain/entities/negocio.dart';
import '../../domain/entities/servicio.dart';

class NegociosMock {
  const NegociosMock._();

  static List<Negocio> build() {
    return const [
      Negocio(
        id: 1,
        nombre: 'Captain Barbershop',
        direccion: 'Manzana F Casa 7 · Tuluá, Valle del Cauca',
        telefono: '+57 315 234 5678',
        correo: 'contacto@captainbarbershop.co',
        horarioGeneral: 'Lun - Sáb · 8:00 a.m. - 8:00 p.m.',
        imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
        serviciosDestacados: [
          Servicio(
            id: 101,
            nombre: 'Corte premium con lavado',
            duracion: 45,
            precio: 45000,
            idNegocio: 1,
          ),
          Servicio(
            id: 102,
            nombre: 'Barba clásica con tratamiento',
            duracion: 40,
            precio: 38000,
            idNegocio: 1,
          ),
          Servicio(
            id: 103,
            nombre: 'Paquete spa facial masculino',
            duracion: 60,
            precio: 65000,
            idNegocio: 1,
          ),
        ],
      ),
      Negocio(
        id: 2,
        nombre: 'Urban Style Studio',
        direccion: 'Calle 10 # 5-20 · Tuluá, Valle',
        telefono: '+57 312 000 1122',
        correo: 'reservas@urbanstyle.com',
        horarioGeneral: 'Todos los días · 9:00 a.m. - 7:00 p.m.',
        imageUrl: 'https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?auto=format&fit=crop&w=800&q=80',
        serviciosDestacados: [
          Servicio(
            id: 201,
            nombre: 'Coloración balayage',
            duracion: 120,
            precio: 180000,
            idNegocio: 2,
          ),
          Servicio(
            id: 202,
            nombre: 'Peinado para eventos',
            duracion: 75,
            precio: 85000,
            idNegocio: 2,
          ),
        ],
      ),
      Negocio(
        id: 3,
        nombre: 'Spa & Glam',
        direccion: 'Carrera 23 # 12-34 · Tuluá',
        telefono: '+57 300 998 8877',
        correo: 'hola@spaglam.co',
        horarioGeneral: 'Mié - Dom · 10:00 a.m. - 9:00 p.m.',
        imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80',
        serviciosDestacados: [
          Servicio(
            id: 301,
            nombre: 'Masaje relajante',
            duracion: 60,
            precio: 90000,
            idNegocio: 3,
          ),
          Servicio(
            id: 302,
            nombre: 'Spa de manos y pies',
            duracion: 50,
            precio: 70000,
            idNegocio: 3,
          ),
          Servicio(
            id: 303,
            nombre: 'Tratamiento capilar nutritivo',
            duracion: 45,
            precio: 80000,
            idNegocio: 3,
          ),
        ],
      ),
    ];
  }
}
