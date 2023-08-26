class Movie {
  final int id;
  final double puntaje;
  final String titulo;
  final String sinopsis;
  final String poster;
  final String fondo;
  final String fecha;

  Movie({
    required this.id,
    required this.puntaje,
    required this.titulo,
    required this.sinopsis,
    required this.poster,
    required this.fondo,
    required this.fecha,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?? '',
      titulo: json['title'] ?? '',
      sinopsis: json['overview'] ?? '',
      poster: json['poster_path'] ?? '',
      fondo: json['backdrop_path'] ?? '',
      puntaje: (json['vote_average']).toDouble() ?? '',
      fecha: json['release_date'] ?? '',
    );
  }
}
