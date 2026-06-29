import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'CatalogoPeliculas.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool cargando = false;

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      _mostrarError('Por favor completa todos los campos');
      return;
    }

    setState(() => cargando = true);

    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      String rol = 'usuario';
      final datos = await Supabase.instance.client
          .from('usuarios')
          .select('rol')
          .eq('auth_id', res.user!.id)
          .maybeSingle();
      if (datos != null && datos['rol'] != null) {
        rol = datos['rol'] as String;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CatalogoPeliculas(esAdmin: rol == 'admin'),
          ),
        );
      }
    } on AuthException catch (e) {
      _mostrarError(e.message);
    } catch (e) {
      _mostrarError('Ocurrió un error inesperado');
    } finally {
      if (mounted) setState(() => cargando = false);
    }
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
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
                onPressed: cargando ? null : login,
                child: cargando
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}