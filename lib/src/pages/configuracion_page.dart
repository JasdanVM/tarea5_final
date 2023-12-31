import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/language_controller.dart';
import '../models/colors.dart';
import '../models/language.dart';

import '../shared/constantes.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle blancoText = TextStyle(color: Colors.white);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Center(
        child: Padding(
        padding: EdgeInsets.only(
          top: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 15,
          right: 15),
          child: Column(
            children: [
              const Spacer(),
              const Text('Cambiar Idioma de Peliculas en la Lista'),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                    MaterialStateProperty.all<Color>(CustomColor.cAzul),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
                onPressed: (){
                    _changeLanguage(lang: 'en');
                    Navigator.pushNamed(context, Rutas.pantallaListaPeliculas.name);
                  },
                child: const Text(
                  'English',
                  style: blancoText,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                    MaterialStateProperty.all<Color>(CustomColor.cAzul),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
                onPressed: (){
                  _changeLanguage(lang: 'es');
                  Navigator.pushNamed(context, Rutas.pantallaListaPeliculas.name);
                },
                child: const Text(
                  'Español',
                  style: blancoText,
                ),
              ),
              const Spacer(),
            ],
          )        
        )
      ),
    );
  }

  void _changeLanguage({lang}) {
    final box = GetStorage();
    final loginController = Get.put(LanguageController());
    box.write('language', Idioma(lang).langCode);
    loginController.langCode = Idioma(lang).langCode;
    print(loginController.langCode);
  }

}


