class Servicio {
  const Servicio({
    required this.id,
    required this.nombre,
    required this.duracion,
    required this.precio,
    this.idNegocio,
    this.categoria,
  });

  final int id;
  final String nombre;
  final int duracion;
  final double precio;
  final int? idNegocio;
  final String? categoria;
}
