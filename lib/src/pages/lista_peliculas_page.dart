import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/colors.dart';
import '../controllers/language_controller.dart';
import '../controllers/login_controller.dart';
import '../models/movie.dart';
import '../services/recibir_peliculas.dart';
import '../shared/constantes.dart';

class ListaPeliculasScreen extends StatefulWidget {
  const ListaPeliculasScreen({Key? key}) : super(key: key);

  @override
  _ListaPeliculasScreenState createState() => _ListaPeliculasScreenState();
}

class _ListaPeliculasScreenState extends State<ListaPeliculasScreen> {
  final languageController = Get.put(LanguageController());
  final loginController = Get.put(LoginController());
  bool showBtn = false;
  List<Movie> peliculas = [];
  final box = GetStorage();
  int currentPage = 1;
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cargarPeliculas();

    _scrollController.addListener(() {
      double showOffset = 10.0; //Back to top botton will show on scroll offset 10.0
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _cargarPeliculas();
      }
      
      if(_scrollController.offset > showOffset){
        showBtn = true;
        setState(() {
         //update state 
        });
      }else{
        showBtn = false;
        setState(() {
          //update state 
        });
      }
    });
  }

  Future<void> _cargarPeliculas() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final movies = await Tmdb().fetchPopularMovies(currentPage);
      setState(() {
        peliculas.addAll(movies);
        currentPage++;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle blancoText = TextStyle(color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.cIndigo,
        iconTheme:
            const IconThemeData(color: CustomColor.cAzul),
        title: (languageController.langCode == '')
            ? const Text(
                'Popular Movies List',
                style: blancoText,
              )
            : const Text(
                'Lista de Películas Populares',
                style: blancoText,
              ),
        // automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        shadowColor: CustomColor.cIndigo,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: CustomColor.cIndigoGris,
              ),
              child: ListTile(
                onTap: () {},
                leading: const Icon(
                  Icons.person,
                  size: 50,
                ), //imagen de perfil, de haberla
                title:
                    Text('Hola ${loginController.userName}', style: blancoText),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .pushNamed(Rutas.pantallaConfiguracion.name);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                box.remove('token');
                box.remove('user');
                Navigator.of(context).pushNamed(Rutas.inicioSesion.name);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),  
        opacity: showBtn?1.0:0.0, 
        child: FloatingActionButton( 
          onPressed: () {  
            _scrollController.animateTo( 
              0,
              duration: const Duration(milliseconds: 500), 
              curve:Curves.fastOutSlowIn
            );
          },
          backgroundColor: CustomColor.cAzul.withOpacity(0.5),
          child: const Icon(Icons.arrow_upward, color: Colors.white,),
        ), 
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: peliculas.length + 1,
          itemBuilder: (context, index) {
            if (index < peliculas.length) {
              final pelicula = peliculas[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context, Rutas.pantallaPelicula.name,
                        arguments: pelicula
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          pelicula.poster.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Builder(
                                    builder: (context) {
                                      try{
                                        return Image.network(
                                          'https://image.tmdb.org/t/p/w92${pelicula.poster}',
                                          height: 100
                                        );
                                      }catch (e){
                                        return const Icon(Icons.broken_image);
                                      } 
                                    }
                                  ),
                                )
                              : const Icon(Icons.movie),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: 
                              Text(pelicula.titulo,softWrap: true,maxLines: 2,overflow: TextOverflow.ellipsis),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          CircularPercentIndicator(
                            radius: 20.0,
                            lineWidth: 5.0,
                            percent: pelicula.puntaje/10,
                            center: Text((pelicula.puntaje*10).toStringAsFixed(0) ),
                            progressColor: CustomColor.cVerde,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 0.5,
                      width: double.infinity,
                      color: CustomColor.cVerdeGris,
                    ),
                  )
                ],
              );
            } else if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: CustomColor.cVerde,),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
