import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';
import 'pelicula_screen.dart';

class ListaPeliculasScreen extends StatefulWidget {
  const ListaPeliculasScreen({Key? key}) : super(key: key);

  @override
  _ListaPeliculasScreenState createState() => _ListaPeliculasScreenState();
}

class _ListaPeliculasScreenState extends State<ListaPeliculasScreen> {
  List<Movie> peliculas = [];

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
  }

  Future<void> _fetchPopularMovies() async {
    const apiKey = 'd6430e4ce739c97e3c67ddb93fb98e25';
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        peliculas = (data['results'] as List)
            .map((datosPelicula) => Movie(
                  id: datosPelicula['id'],
                  titulo: datosPelicula['title'],
                  sinopsis: datosPelicula['sinopsis'],
                  poster: datosPelicula['poster'],
                  fecha: datosPelicula['fecha'],
                ))
            .toList();
      });
    } else {
      throw Exception('Error al cargar las peliculas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú de Películas')),
      body: ListView.builder(
        itemCount: peliculas.length,
        itemBuilder: (context, index) {
          final pelicula = peliculas[index];
          return ListTile(
            leading: pelicula.poster != null
                ? Image.network(
                    'https://image.tmdb.org/t/p/w92${pelicula.poster}')
                : const Icon(Icons.movie),
            title: Text(pelicula.titulo),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PeliculaScreen(movie: pelicula),
                ),
              );
            },
          );
        },
      ),
    );
  }
}