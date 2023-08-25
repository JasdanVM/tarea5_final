import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/language_controller.dart';
import '../controllers/login_controller.dart';
import '../models/movie.dart';
import '../services/recibir_peliculas.dart';
import '../shared/constantes.dart';
import 'pelicula_page.dart';

class ListaPeliculasScreen extends StatefulWidget {
  const ListaPeliculasScreen({Key? key}) : super(key: key);

  @override
  _ListaPeliculasScreenState createState() => _ListaPeliculasScreenState();
}

class _ListaPeliculasScreenState extends State<ListaPeliculasScreen> {
  final languageController = Get.put(LanguageController());
  final loginController = Get.put(LoginController());
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
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _cargarPeliculas();
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
        backgroundColor: const Color.fromARGB(255, 10, 38, 64),
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 25, 184, 217)),
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
        shadowColor: const Color.fromARGB(255, 25, 184, 217),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 40, 50, 60),
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
                Navigator.of(context).pushNamed(Rutas.inicioSesion.name);
              },
            ),
          ],
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
                      // Navigator.pushNamed(
                      //     context, Rutas.pantallaListaPeliculas.name,
                      //     arguments: pelicula);
                      Navigator.pushNamed(
                          context, Rutas.pantallaPelicula.name,
                          arguments: pelicula);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          pelicula.poster != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                      'https://image.tmdb.org/t/p/w92${pelicula.poster}',
                                      height: 100),
                                )
                              : const Icon(Icons.movie),
                          const SizedBox(
                            width: 40,
                          ),
                          Expanded(
                            child: 
                              Text(pelicula.titulo,softWrap: true,maxLines: 2,overflow: TextOverflow.ellipsis),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 0.5,
                      width: double.infinity,
                      color: const Color.fromARGB(128, 138, 205, 135),
                    ),
                  )
                ],
              );
            } else if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color.fromARGB(255, 73, 209, 79),),
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
