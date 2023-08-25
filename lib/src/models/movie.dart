class Movie {
  final int id;
  final String titulo;
  final String sinopsis;
  final String poster;
  final String fecha;

  Movie({
    required this.id,
    required this.titulo,
    required this.sinopsis,
    required this.poster,
    required this.fecha,
  });

  Movie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        titulo = json['titulo'],
        sinopsis = json['sinopsis'],
        poster = json['poster'],
        fecha = json['fecha'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'sinopsis': sinopsis,
      'poster': poster,
      'fecha': fecha,
    };
  }

}
