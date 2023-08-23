
import '../pages/login_screen.dart';
import '../pages/lista_peliculas_screen.dart';
import '../pages/pelicula_screen.dart';
import 'constantes.dart';

final rutas = {
  Rutas.inicioSesion.name: (context) => const LoginScreen(),
  Rutas.pantallaListaPeliculas.name: (context) => const ListaPeliculasScreen(),
  Rutas.pantallaPelicula.name: (context) => const PeliculaScreen(movie: movie),
};
