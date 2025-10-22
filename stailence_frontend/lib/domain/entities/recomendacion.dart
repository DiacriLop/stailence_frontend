class Recomendacion {
  const Recomendacion({
    required this.id,
    this.tipoRostro,
    this.corteSugerido,
    this.idCliente,
  });

  final int id;
  final String? tipoRostro;
  final String? corteSugerido;
  final int? idCliente;
}
