import 'package:flutter/material.dart';
import '../data/usuarios.dart';
import 'CatalogoPeliculas.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CuerpoLogin();
  }
}

class CuerpoLogin extends StatelessWidget {
  const CuerpoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: formularioLogin(context),
    );
  }
}

Widget formularioLogin(BuildContext context) {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  return Padding(
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => login(context, email, password),
            child: Text('Entrar'),
          ),
        ),
      ],
    ),
  );
}

void login(BuildContext context, email, password) {
  final usuario = Usuarios.lista.firstWhere(
    (u) => u.email == email.text && u.password == password.text,
    orElse: () => Usuario(nombre: '', email: '', password: ''),
  );

  if (usuario.email.isEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Correo o contraseña incorrectos'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CatalogoPeliculas()),
    );
  }
}
