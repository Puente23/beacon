class Ubicaciones {
  /*CREATE TABLE ubicaciones(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ubicacion TEXT,
            nombre TEXT,
            gps TEXT*/
  final int id;
  final String ubicacion;
  final String nombre;
  final String gps;
  static const String TABLENAME = "ubicaciones";
  Ubicaciones(
      {required this.id,
      required this.ubicacion,
      required this.nombre,
      required this.gps});
  Map<String, dynamic> toMap() {
    return {'id': id, 'ubicacion': ubicacion, 'nombre': nombre, 'gps': gps};
  }
}
