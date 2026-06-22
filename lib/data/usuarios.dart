class Usuario {
  String nombre;
  String email;
  String password;

  Usuario({required this.nombre, required this.email, required this.password});
}

class Usuarios {
  static List<Usuario> lista = [
    Usuario(nombre: 'Admin', email: 'admin@test.com', password: '123456'),
  ];
}
