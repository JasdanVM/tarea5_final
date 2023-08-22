import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/album.dart';
// import '../models/user_login.dart';

  Future<Album> crearAlbum({required String usuario, required String contrasenia}) async {
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usuario,
        'password': contrasenia,
      }),
    );
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
    throw Exception('Fallo al crear album');
  }
  }
