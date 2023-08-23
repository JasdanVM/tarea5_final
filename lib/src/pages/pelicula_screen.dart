import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';
import '../models/cast.dart';

class PeliculaScreen extends StatefulWidget {
  final Movie movie;

  const PeliculaScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _PeliculaScreenState createState() => _PeliculaScreenState();
}

class _PeliculaScreenState extends State<PeliculaScreen> {
  List<Cast> cast = [];

  @override
  void initState() {
    super.initState();
    _fetchMovieCast();
  }

  Future<void> _fetchMovieCast() async {
    const apiKey = 'd6430e4ce739c97e3c67ddb93fb98e25'; // Your provided API key
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movie.id}/credits?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        cast = (data['cast'] as List)
            .map((castData) => Cast(
                  id: castData['id'],
                  nombre: castData['nombre'],
                  personaje: castData['personaje'],
                  perfil: castData['perfil'],
                ))
            .toList();
      });
    } else {
      throw Exception('Error al cargar el cast');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.titulo)),
      body: Column(
        children: [
          if (widget.movie.poster.isNotEmpty)
            Image.network(
                'https://image.tmdb.org/t/p/w185${widget.movie.poster}'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.movie.sinopsis),
          ),
          const Text('Actores:'),
          Expanded(
            child: ListView.builder(
              itemCount: cast.length,
              itemBuilder: (context, index) {
                final castItem = cast[index];
                return ListTile(
                  leading: castItem.perfil.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w92${castItem.perfil}')
                      : const Icon(Icons.person),
                  title: Text(castItem.nombre),
                  subtitle: Text(castItem.personaje),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}