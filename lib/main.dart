
import 'package:get_storage/get_storage.dart';

import 'src/shared/constantes.dart';
import 'src/shared/rutas.dart';
import 'src/shared/not_found.dart';
import 'package:flutter/material.dart';



void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      title: 'Tarea 3 por JV & AG',
      initialRoute: Rutas.inicioSesion.name,
      routes: rutas,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          return const NotFound();
        });
      },
    );
  }
}
