
import '../pages/login_page.dart';
import '../pages/lista_peliculas_page.dart';
//import '../pages/pelicula_screen.dart';
import '../pages/configuracion_page.dart';
import 'constantes.dart';

final rutas = {
  Rutas.inicioSesion.name: (context) => const LoginScreen(),
  Rutas.pantallaListaPeliculas.name: (context) => const ListaPeliculasScreen(),
  //TODORutas.pantallaPelicula.name: (context) => const PeliculaScreen(),
  Rutas.pantallaConfiguracion.name: (context) => const ConfiguracionScreen()
};
