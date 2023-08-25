import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/login_controller.dart';
import '../models/respuesta.dart';
import '../services/enviar_datos.dart';
import '../shared/constantes.dart';
import '../widgets/input_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usuarioController = TextEditingController();
  final contraseniaController = TextEditingController();
  Future<RespuestaLogin>? _futureResponse;
  final formKey = GlobalKey<FormState>();
  final box = GetStorage();
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 38, 64),
        title: const Text('Login',
          style: TextStyle(color: Colors.white, fontSize: 18), 
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Obx(
          () {
            if (loginController.loginOutput.isNotEmpty && box.read('token') != null) {
              _iniciando();
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image(
                      image: AssetImage('assets/tmdb_logo_2.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    ),
                  Text('Bienvenido(a) ${loginController.userName}'),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(color: Color.fromARGB(255, 73, 209, 79),),
                  const Spacer(),
                ],
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 15,
                  right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Image(
                        image: AssetImage('assets/tmdb_logo.png'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InputForm(
                            label: 'Ingrese su usuario',
                            icon: Icons.person,
                            controller: usuarioController,
                            validator: (value) {
                              if (value!.length < 1) {
                                return 'Ingrese un usuario válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InputForm(
                            label: 'Ingrese su contraseña',
                            icon: Icons.password,
                            obscureText: true,
                            mostrarBoton: true,
                            controller: contraseniaController,
                            validator: (value) {
                              if (value!.length < 1) {
                                contraseniaController.clear();
                                return 'Debe ingresar su contraseña';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color.fromARGB(255, 25, 184, 217)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      onPressed: _verifyLogin,
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _verifyLogin() async {
    if (formKey.currentState!.validate()) {
      _futureResponse = iniciarSesion(
          usuario: usuarioController.text,
          contrasenia: contraseniaController.text);
      try {
        final response = await _futureResponse;
        _showSnackBar('Iniciando sesión...');
        await box.write('token', response!.token);
        loginController.loginOutput = response.token;
        await box.write('user', usuarioController.text);
        loginController.userName = usuarioController.text;

        _iniciando();
      } catch (e) {
        _showSnackBar('Credenciales inválidas. Por favor, inténtelo otra vez.');
        contraseniaController.clear();
      }
    } else {
      _showSnackBar('Acceso inválido. Por favor, inténtelo otra vez.');
      contraseniaController.clear();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _iniciando() async {
    if (loginController.loginOutput.isNotEmpty) {
      print(loginController.loginOutput.toString());
    }
    await Future.delayed(const Duration(seconds: 4),
      () => Navigator.pushNamed(context, Rutas.pantallaListaPeliculas.name));
  }

}