import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  @override
  void initState() {
    super.initState();
    _cargarPeliculas();
  }

  Future<void> _cargarPeliculas() async {
    try {
      final movies = await Tmdb().fetchPopularMovies();
      setState(() {
        peliculas = movies;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle blancoText = TextStyle(color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 38, 64),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 25, 184, 217)),
        title: (languageController.langCode=='') ? 
          const Text('Popular Movies List',style: blancoText,) : const Text('Lista de Películas Populares',style: blancoText,),
        // automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        shadowColor: Color.fromARGB(255, 25, 184, 217),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 40, 50, 60),
              ),
              child: ListTile(
                onTap: () {},
                leading: Icon(Icons.person,size: 50, ), //imagen de perfil, de haberla
                title: Text('Hola ${loginController.userName}',style: blancoText),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(Rutas.pantallaConfiguracion.name);
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
          itemCount: peliculas.length,
          itemBuilder: (context, index) {
            final pelicula = peliculas[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Rutas.pantallaListaPeliculas.name,
                      arguments: pelicula);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PeliculaScreen(movie: pelicula),
                      ),
                    );
                  } ,
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          pelicula.poster != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                  'https://image.tmdb.org/t/p/w92${pelicula.poster}',height: 100),
                            )
                            : const Icon(Icons.movie),
                          const SizedBox(
                            width: 40,
                          ),
                          Text(pelicula.titulo)
                        ],
                      ),
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    height: 0.5,
                    width: double.infinity,
                    color: Color.fromARGB(128, 138, 205, 135),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
