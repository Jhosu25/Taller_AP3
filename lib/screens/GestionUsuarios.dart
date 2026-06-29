import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GestionUsuarios extends StatefulWidget {
  const GestionUsuarios({super.key});

  @override
  State<GestionUsuarios> createState() => _GestionUsuariosState();
}

class _GestionUsuariosState extends State<GestionUsuarios> {
  late Future<List<Map<String, dynamic>>> _futuro;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    setState(() {
      _futuro = _obtenerUsuarios();
    });
  }


  Future<List<Map<String, dynamic>>> _obtenerUsuarios() async {
    final datos = await Supabase.instance.client
        .from('usuarios')
        .select()
        .order('id', ascending: true);
    return (datos as List).cast<Map<String, dynamic>>();
  }


  Future<void> _editar(Map<String, dynamic> u) async {
    final cambio = await showDialog<bool>(
      context: context,
      builder: (_) => _DialogoEditar(usuario: u),
    );
    if (cambio == true) _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar usuarios'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _cargar),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final usuarios = snapshot.data ?? [];
          if (usuarios.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados.'));
          }
          return ListView.separated(
            itemCount: usuarios.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final u = usuarios[i];
              return ListTile(
                leading: CircleAvatar(child: Text('${u['rol'] == 'admin' ? 'A' : 'U'}')),
                title: Text('${u['nombre']}  (${u['rol']})'),
                subtitle: Text(
                  '${u['email']}\nEdad: ${u['edad']}  •  ${u['ciudad']}  •  ${u['telefono']}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  tooltip: 'Editar',
                  onPressed: () => _editar(u),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class _DialogoEditar extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const _DialogoEditar({required this.usuario});

  @override
  State<_DialogoEditar> createState() => _DialogoEditarState();
}

class _DialogoEditarState extends State<_DialogoEditar> {
  late final TextEditingController nombre;
  late final TextEditingController edad;
  late final TextEditingController ciudad;
  late final TextEditingController telefono;
  late String rol;
  bool guardando = false;

  @override
  void initState() {
    super.initState();
    final u = widget.usuario;
    nombre = TextEditingController(text: '${u['nombre'] ?? ''}');
    edad = TextEditingController(text: '${u['edad'] ?? ''}');
    ciudad = TextEditingController(text: '${u['ciudad'] ?? ''}');
    telefono = TextEditingController(text: '${u['telefono'] ?? ''}');
    rol = '${u['rol'] ?? 'usuario'}';
  }

  @override
  void dispose() {
    nombre.dispose();
    edad.dispose();
    ciudad.dispose();
    telefono.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => guardando = true);
    try {
      await Supabase.instance.client.from('usuarios').update({
        'nombre': nombre.text.trim(),
        'edad': int.tryParse(edad.text.trim()) ?? widget.usuario['edad'],
        'ciudad': ciudad.text.trim(),
        'telefono': telefono.text.trim(),
        'rol': rol,
      }).eq('id', widget.usuario['id']);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar: ${widget.usuario['email']}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombre, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: edad, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Edad')),
            TextField(controller: ciudad, decoration: const InputDecoration(labelText: 'Ciudad')),
            TextField(controller: telefono, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Teléfono')),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: rol,
              decoration: const InputDecoration(labelText: 'Rol'),
              items: const [
                DropdownMenuItem(value: 'usuario', child: Text('usuario')),
                DropdownMenuItem(value: 'admin', child: Text('admin')),
              ],
              onChanged: (v) => setState(() => rol = v ?? 'usuario'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: guardando ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: guardando ? null : _guardar,
          child: guardando
              ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Guardar'),
        ),
      ],
    );
  }
}