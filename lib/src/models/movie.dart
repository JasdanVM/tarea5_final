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

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?? '',
      titulo: json['title'] ?? '',
      sinopsis: json['overview'] ?? '',
      poster: json['poster_path'] ?? '',
      fecha: json['release_date'] ?? '',
    );
  }
}
