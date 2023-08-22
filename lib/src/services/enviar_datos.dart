import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_login.dart';

class EnviarPost {
  Future<http.Response> crearAlbum({required String usuario,required String contrasenia}) {
    return http.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usuario,
        'password': contrasenia,
      }),
    );
  }
}

