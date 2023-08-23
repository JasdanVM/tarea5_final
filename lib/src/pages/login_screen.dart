import 'package:flutter/material.dart';
import '../models/album.dart';
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
  Future<RespuestaLogin>? _futureAlbum;
  final formKey = GlobalKey<FormState>();
  // LoginProvider get service => GetIt.I<LoginProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla de Login'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
              padding: EdgeInsets.only(
                        top: 15, bottom: MediaQuery.of(context).viewInsets.bottom, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Image(
                          image: AssetImage('assets/tmdb_logo.png'),
                    ),
                    height: 200,
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
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow), 
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), 
                        ),
                      ),
                    ),
                    onPressed: _verifyLogin,
                    child: const Text('Iniciar sesión',style: TextStyle(color: Color.fromARGB(255, 7, 48, 82)),),
                    
                  ),
                  const Spacer(),           
                ],
              ),
            )
      );
  }

  void _verifyLogin() async{

    if (formKey.currentState!.validate()) {
      setState(() {
          _futureAlbum = iniciarSesion(usuario: usuarioController.text,contrasenia: contraseniaController.text);
        });

      try{
        await _futureAlbum;  
        _showSnackBar('Iniciando sesión...');
        await Future.delayed(
          const Duration(seconds: 2),
          () => Navigator.pushNamed(context, 'Inexistente')
          );
        
      }catch(e){
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
}
