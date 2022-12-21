class Beacon {
  final int id;
  final String nombre;
  final String ubicacion;
  static const String TABLENAME = "beacons";
  Beacon({required this.id, required this.nombre, required this.ubicacion});
  Map<String, dynamic> toMap() {
    return {'id': id, 'ubicacion': ubicacion, 'nombre': nombre};
  }
}
