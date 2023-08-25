import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/language_controller.dart';
import '../models/movie.dart';
import '../models/cast.dart';
import '../services/recibir_peliculas.dart';

class PeliculaScreen extends StatefulWidget {
  final Movie movie;

  const PeliculaScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _PeliculaScreenState createState() => _PeliculaScreenState();
}

class _PeliculaScreenState extends State<PeliculaScreen> {
  final languageController = Get.put(LanguageController());
  List<Cast> cast = [];

  @override
  void initState() {
    super.initState();
    _fetchMovieCast();
  }

  // Future<void> _cargarPelicula() async {
  //   try {
  //     final movie = await Tmdb().fetchMovieCast();
  //     setState(() {
  //       pelicula = movie;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> _fetchMovieCast() async {
    const apiKey = 'd6430e4ce739c97e3c67ddb93fb98e25';
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
                  nombre: castData['name'] ?? '',
                  personaje: castData['character'] ?? '',
                  perfil: castData['profile_path'] ?? '',
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
          GestureDetector(
            onTap: () {
              _showPosterDialog();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w185${widget.movie.poster}',
              ),
            ),
          ),
          Builder(builder: (context) => (languageController.langCode=='') ? const Text('Description:') : const Text('Descripción:')    
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.movie.sinopsis),
          ),
          Builder(builder: (context) => (languageController.langCode=='') ? const Text('Release date:') : const Text('Fecha de lanzamiento:')    
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.movie.fecha),
          ),
          Builder(builder: (context) => (languageController.langCode=='') ? const Text('Cast:') : const Text('Actores/Actrices:')    
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cast.length,
              itemBuilder: (context, index) {
                final castItem = cast[index];
                return ListTile(
                  leading: castItem.perfil.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                            'https://image.tmdb.org/t/p/w92${castItem.perfil}'),
                      )
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

  void _showPosterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.network(
            'https://image.tmdb.org/t/p/w500${widget.movie.poster}',
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
