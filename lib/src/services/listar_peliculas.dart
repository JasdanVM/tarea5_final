// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../models/movie.dart';

// Future<void> _fetchPopularMovies() async {
//   List<Movie> peliculas = [];
//     const apiKey = 'd6430e4ce739c97e3c67ddb93fb98e25';
//     final response = await http.get(
//       Uri.parse(
//           'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=es-ES'),
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         peliculas = (data['results'] as List)
//             .map((datosPelicula) => Movie(
//                   id: datosPelicula['id'],
//                   titulo: datosPelicula['title'] ?? '',
//                   sinopsis: datosPelicula['overview'] ?? '',
//                   poster: datosPelicula['poster_path'] ?? '',
//                   fecha: datosPelicula['release_date'] ?? '',
//                 ))
//             .toList();
//       });
//     } else {
//       throw Exception('Error al cargar las peliculas');
//     }
//   }