class Usuario {
  final int id;
  final String nombre;
  final String tipo;
  final String apellido_M;
  final String apellido_P;
  final int id_dispositivo;
  static const String TABLENAME = "usuarios";
  Usuario(
      {required this.id,
      required this.nombre,
      required this.tipo,
      required this.apellido_M,
      required this.apellido_P,
      required this.id_dispositivo});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'apellido_M': apellido_M,
      'apellido_P': apellido_P,
      'id_dispositivo': id_dispositivo
    };
  }
}
