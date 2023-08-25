import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/language_controller.dart';
import '../models/cast.dart';
import '../models/movie.dart';

class Tmdb {
  static const apiKey = 'd6430e4ce739c97e3c67ddb93fb98e25';
  final languageController = Get.put(LanguageController());
  
  Future<List<Movie>> fetchPopularMovies(currentPage) async {
  final response = await http.get(
    Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey${languageController.langCode}&page=$currentPage'
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return (data['results'] as List)
      .map((datosPelicula) => Movie.fromJson(datosPelicula)
      ).toList();
  } else {
    throw Exception('Error al cargar las peliculas');
  }
}

  Future<List<Cast>> fetchMovieCast(movie) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
        return (data['cast'] as List)
          .map((castData) => Cast.fromJson(castData)
          ).toList();
    } else {
      throw Exception('Error al cargar el cast');
    }
  }

}

