import 'package:flutter/material.dart';
import '../data/usuarios.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CuerpoRegistro();
  }
}

class CuerpoRegistro extends StatelessWidget {
  const CuerpoRegistro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrarse')),
      body: formularioRegistro(context),
    );
  }
}

Widget formularioRegistro(BuildContext context) {
  TextEditingController nombre = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  return Padding(
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: nombre,
          decoration: InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
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
            onPressed: () => registrar(context, nombre, email, password),
            child: Text('Crear cuenta'),
          ),
        ),
      ],
    ),
  );
}

void registrar(BuildContext context, nombre, email, password) {
  if (nombre.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Todos los campos son obligatorios'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
    return;
  }

  final existe = Usuarios.lista.any((u) => u.email == email.text);
  if (existe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Ya existe una cuenta con ese correo'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
    return;
  }

  Usuarios.lista.add(Usuario(nombre: nombre.text, email: email.text, password: password.text));

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Éxito'),
      content: Text('Cuenta creada exitosamente'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text('Aceptar'),
        ),
      ],
    ),
  );
}
