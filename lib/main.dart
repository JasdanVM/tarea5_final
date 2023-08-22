import 'src/providers/login_provider.dart';
import 'src/shared/constantes.dart';
import 'src/shared/rutas.dart';
import 'src/shared/not_found.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => LoginProvider());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      title: 'Material App',
      initialRoute: Rutas.inicio.name, // '/home'
      routes: rutas,
      onGenerateRoute: (settings) {
        // print(settings.name);
        return MaterialPageRoute(builder: (context) {
          return const NotFound();
        });
      },
    );
  }
}
