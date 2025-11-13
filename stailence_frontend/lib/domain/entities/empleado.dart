class Empleado {
  const Empleado({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
  });

  final int id;
  final String nombre;
  final String apellido;
  final String correo;
}
