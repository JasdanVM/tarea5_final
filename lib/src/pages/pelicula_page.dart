import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/colors.dart';
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
    const TextStyle tsN = TextStyle(fontWeight: FontWeight.bold);
    final titleSize = movie.titulo.length;

    return Scaffold(
      appBar: AppBar(
        title: ( titleSize >  35) ?
        SizedBox(
          height: 30,
          child: Marquee(
            startAfter: const Duration(seconds: 2),
            text: movie.titulo,
            style: tsN,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 200.0,
            velocity: 35.0,
            pauseAfterRound: const Duration(seconds: 1),
            startPadding: 10.0,
            fadingEdgeStartFraction: 0.1,
            fadingEdgeEndFraction: 0.1,
          ),
        ) : Text(movie.titulo,style: tsN),
      ),
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
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Builder(
                        builder: (context) {
                          try{
                            return Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.fondo}',
                              fit: BoxFit.cover,
                            );
                          }catch (e){
                            return const Icon(Icons.broken_image);
                          }
                        }
                      ),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/poster_placeholder.png',
                          image: 'https://image.tmdb.org/t/p/w185${movie.poster}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  LinearPercentIndicator(
                    barRadius: Radius.circular(5),
                    backgroundColor: CustomColor.cIndigoGris,
                    fillColor: Color.fromARGB(255, 11, 28, 34),
                    progressColor: CustomColor.cVerdeGris,
                    alignment: MainAxisAlignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: 200,
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Puntación de Usuarios: ${(movie.puntaje*10).toStringAsFixed(0)}%',style: const TextStyle(fontSize: 12, color: Colors.white),),
                    ),
                    percent: movie.puntaje/10,
                  ),
                ],
              ),
              const SizedBox(height: 7,),
              (languageController.langCode=='') ? const Text('Description:',style: tsN) : const Text('Descripción:',style: tsN),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,top:7,bottom: 7),
                child: GestureDetector(
                  onTap: () => _showOverviewDialog(),
                  child: Text(
                    movie.sinopsis.isNotEmpty ? movie.sinopsis : ' ... ' ,
                    maxLines: 5,overflow: TextOverflow.ellipsis
                  )
                ),
              ),
              (languageController.langCode=='') ? const Text('Release date:',style: tsN) : const Text('Fecha de lanzamiento:',style: tsN),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  languageController.langCode=='' ? movie.fecha : normalDate(movie.fecha)
                ),
              ),
              (languageController.langCode=='') ? const Text('Cast:',style: tsN) : const Text('Actores/Actrices:',style: tsN),
              Expanded(
                child: ListView.builder(
                  itemCount: castList.length,
                  itemBuilder: (context, index) {
                    final castItem = castList[index];
                    return ListTile(
                      leading: castItem.perfil.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Builder(
                              builder: (context) {
                                try{
                                  return Image.network(
                                    'https://image.tmdb.org/t/p/w92${castItem.perfil}');
                                }catch (e){
                                  return const Icon(Icons.broken_image);
                                }
                              }
                            ),
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
        try{
          return Dialog(
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.poster}',
              fit: BoxFit.contain,
            ),
          );
        }catch (e){
          return const Dialog(
            child: Icon(Icons.broken_image)
          );
        }
      },
    );
  }

  void _showOverviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              movie.sinopsis.isNotEmpty ? movie.sinopsis : 
              (languageController.langCode=='') ? 'Overview not found.' : 'No se ha encontrado descripción.',
            ),
          ),
        );
      },
    );
  }

  String normalDate(String date) {
    List<String> parts = date.split('-');
    if (parts.length == 3) {
      String d = parts[2];
      String m = parts[1];
      String a = parts[0];
      return '$d-$m-$a';
    } else {
      return date;
    }
  }

}
