import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tarea5_final/src/models/colors.dart';
import '../controllers/language_controller.dart';
import '../models/movie.dart';
import '../models/cast.dart';
import '../services/recibir_peliculas.dart';

class PeliculaPage extends StatefulWidget {
  const PeliculaPage({super.key});

  @override
  _PeliculaPageState createState() => _PeliculaPageState();
}

class _PeliculaPageState extends State<PeliculaPage> {
  final languageController = Get.put(LanguageController());
  late Movie movie;
  late List<Cast> castList = [];

  @override
  void initState() {
    super.initState();
    _cargarPelicula();
  }

  Future<void> _cargarPelicula() async {
    try {
      final movieCast = await Tmdb().fetchMovieCast(movie);
      setState(() {
        castList = movieCast;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
      appBar: AppBar(title: Text(movie.titulo)),
      body: FutureBuilder<void>(
      future: _cargarPelicula(),
      builder: (context, AsyncSnapshot<void> snapshot) {
        if (castList!=[]) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  _showPosterDialog();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w185${movie.poster}',
                  ),
                ),
              ),
              (languageController.langCode=='') ? const Text('Description:') : const Text('Descripción:'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(movie.sinopsis),
              ),
              (languageController.langCode=='') ? const Text('Release date:') : const Text('Fecha de lanzamiento:'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(movie.fecha),
              ),
              (languageController.langCode=='') ? const Text('Cast:') : const Text('Actores/Actrices:'),
              Expanded(
                child: ListView.builder(
                  itemCount: castList.length,
                  itemBuilder: (context, index) {
                    final castItem = castList[index];
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
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: CustomColor.cVerde,)
            );
        }
      }
    )
    );
  }

  void _showPosterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Image.network(
            'https://image.tmdb.org/t/p/w500${movie.poster}',
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
