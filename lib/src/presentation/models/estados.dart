class Estados {
  final int id;
  final String tipo;
  static const String TABLENAME = "estados";
  Estados({required this.id, required this.tipo});
  Map<String, dynamic> toMap() {
    return {'id': id, 'tipo': tipo};
  }
}
