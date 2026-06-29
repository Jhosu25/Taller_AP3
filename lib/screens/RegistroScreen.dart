import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController nombre = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController edad = TextEditingController();
  final TextEditingController ciudad = TextEditingController();
  final TextEditingController telefono = TextEditingController();

  bool cargando = false;

  @override
  void dispose() {
    nombre.dispose();
    email.dispose();
    password.dispose();
    edad.dispose();
    ciudad.dispose();
    telefono.dispose();
    super.dispose();
  }

  Future<void> registrar() async {

    if (nombre.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        edad.text.isEmpty ||
        ciudad.text.isEmpty ||
        telefono.text.isEmpty) {
      _mostrarMensaje('Error', 'Todos los campos son obligatorios');
      return;
    }

    final int? edadNum = int.tryParse(edad.text.trim());
    if (edadNum == null || edadNum <= 0 || edadNum > 120) {
      _mostrarMensaje('Error', 'Ingresa una edad válida');
      return;
    }

    setState(() => cargando = true);

    try {

      final AuthResponse res = await Supabase.instance.client.auth.signUp(
        email: email.text.trim(),
        password: password.text.trim(),
        data: {'nombre': nombre.text.trim()},
      );

      await Supabase.instance.client.from('usuarios').insert({
        'auth_id': res.user?.id,
        'nombre': nombre.text.trim(),
        'email': email.text.trim(),
        'edad': edadNum,
        'ciudad': ciudad.text.trim(),
        'telefono': telefono.text.trim(),
        'rol': 'usuario', // por defecto todos se registran como usuario
      });

      if (mounted) {
        _mostrarMensaje(
          'Éxito',
          'Cuenta creada exitosamente.',
          onAceptar: () {
            Navigator.pop(context); // cierra el diálogo
            Navigator.pop(context); // regresa al login
          },
        );
      }
    } on AuthException catch (e) {
      _mostrarMensaje('Error', e.message);
    } on PostgrestException catch (e) {
      _mostrarMensaje('Error', 'No se pudo guardar el usuario: ${e.message}');
    } catch (e) {
      _mostrarMensaje('Error', 'Ocurrió un error inesperado');
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  void _mostrarMensaje(String titulo, String contenido, {VoidCallback? onAceptar}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          TextButton(
            onPressed: onAceptar ?? () => Navigator.pop(context),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrarse')),
      body: SingleChildScrollView(
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
            SizedBox(height: 16),
            
            TextField(
              controller: edad,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            
            TextField(
              controller: ciudad,
              decoration: InputDecoration(
                labelText: 'Ciudad',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            
            TextField(
              controller: telefono,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cargando ? null : registrar,
                child: cargando
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Crear cuenta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}