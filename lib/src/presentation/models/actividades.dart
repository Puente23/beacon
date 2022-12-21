class Actividades {
  final int id;
  final String nombre;
  final DateTime tiempoIni;
  final DateTime tiempoFin;
  final String estado;

  static const String TABLENAME = "actividad";

  Actividades(
      {required this.id,
      required this.nombre,
      required this.tiempoIni,
      required this.tiempoFin,
      required this.estado});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'tiempoini': tiempoIni,
      'tiempofin': tiempoFin,
      'estado': estado
    };
  }
}
