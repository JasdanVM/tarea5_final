
import '../pages/bienvenida_screen.dart';
import '../pages/login_screen.dart';
import 'constantes.dart';

final rutas = {
  Rutas.inicio.name: (context) => const LoginScreen(),
  Rutas.pantallaBienvenida.name: (context) => const BienvenidaScreen(),
};
