
import '../pages/login_page.dart';
import '../pages/lista_peliculas_page.dart';
import '../pages/pelicula_page.dart';
import '../pages/configuracion_page.dart';
import 'constantes.dart';

final rutas = {
  Rutas.inicioSesion.name: (context) => const LoginScreen(),
  Rutas.pantallaListaPeliculas.name: (context) => const ListaPeliculasScreen(),
  Rutas.pantallaPelicula.name: (context) => const PeliculaPage(),
  Rutas.pantallaConfiguracion.name: (context) => const ConfiguracionScreen()
};
