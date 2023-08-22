class UserLogin{
  String usuario;
  String contrasenia;

  UserLogin({required this.usuario, required this.contrasenia});

  Map<String, dynamic> toJson() {
    return {'usuario': usuario, 'contrasenia': contrasenia};
  }
}