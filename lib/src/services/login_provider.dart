
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_login.dart';

class LoginProvider {
  Future<dynamic> login(String username, String password) {
    final credentials = UserLogin(usuario: username, contrasenia: password);
    return http.post(Uri.parse( 'https://fakestoreapi.com/auth/login'), 
        body: credentials.toJson())
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return jsonData;
      }
    }).catchError((error) => print(error));
  }
}