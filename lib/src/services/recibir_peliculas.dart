import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tarea5_final/src/controllers/language_controller.dart';
import 'dart:convert';

import '../models/cast.dart';
import '../models/movie.dart';

class Tmdb {
  static const apiKey = 'd6430e4ce739c97e3c67ddb93fb98e25';
  final languageController = Get.put(LanguageController());
  
  Future<List<Movie>> fetchPopularMovies() async {
  final response = await http.get(
    Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=${apiKey}${languageController.langCode}'
    ),
  );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return (data['results'] as List)
        .map((datosPelicula) => Movie(
          id: datosPelicula['id'],
          titulo: datosPelicula['title'] ?? '',
          sinopsis: datosPelicula['overview'] ?? '',
          poster: datosPelicula['poster_path'] ?? '',
          fecha: datosPelicula['release_date'] ?? '',
        )).toList();
    } else {
      throw Exception('Error al cargar las peliculas');
    }
  }

  // Future<List<Cast>> fetchMovieCast() async {
  //   final response = await http.get(
  //     Uri.parse(
  //       'https://api.themoviedb.org/3/movie/${widget.movie.id}/credits?api_key=$apiKey'),
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //       return (data['cast'] as List)
  //         .map((castData) => Cast(
  //           id: castData['id'],
  //           nombre: castData['name'] ?? '',
  //           personaje: castData['character'] ?? '',
  //           perfil: castData['profile_path'] ?? '',
  //         )).toList();
  //   } else {
  //     throw Exception('Error al cargar el cast');
  //   }
  // }

}

