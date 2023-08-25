class Cast {
  final int id;
  final String nombre;
  final String personaje;
  final String perfil;

  Cast({
    required this.id,
    required this.nombre,
    required this.personaje,
    required this.perfil,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id']?? '',
      nombre: json['name'] ?? '',
      personaje: json['character'] ?? '',
      perfil: json['profile_path'] ?? '',
    );
  }
}
