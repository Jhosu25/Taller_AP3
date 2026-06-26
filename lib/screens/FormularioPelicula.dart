import 'package:flutter/material.dart';
import 'package:taller_1_am3/data/Pelicula.dart';
import 'package:taller_1_am3/data/PeliculasService.dart';


class FormularioPelicula extends StatefulWidget {
  final Pelicula? pelicula;
  const FormularioPelicula({super.key, this.pelicula});

  @override
  State<FormularioPelicula> createState() => _FormularioPeliculaState();
}

class _FormularioPeliculaState extends State<FormularioPelicula> {
  final _formKey = GlobalKey<FormState>();
  final _servicio = PeliculasService();

  late final TextEditingController _titulo;
  late final TextEditingController _categoria;
  late final TextEditingController _descripcion;
  late final TextEditingController _anio;
  late final TextEditingController _poster;
  late final TextEditingController _video;

  bool _guardando = false;

  bool get _esEdicion => widget.pelicula != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pelicula;
    _titulo = TextEditingController(text: p?.titulo ?? '');
    _categoria = TextEditingController(text: p?.categoria ?? '');
    _descripcion = TextEditingController(text: p?.descripcion ?? '');
    _anio = TextEditingController(text: p != null ? '${p.anio}' : '');
    _poster = TextEditingController(text: p?.poster ?? '');
    _video = TextEditingController(text: p?.video ?? '');
  }

  @override
  void dispose() {
    _titulo.dispose();
    _categoria.dispose();
    _descripcion.dispose();
    _anio.dispose();
    _poster.dispose();
    _video.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final pelicula = Pelicula(
      id: widget.pelicula?.id,
      titulo: _titulo.text.trim(),
      categoria: _categoria.text.trim(),
      descripcion: _descripcion.text.trim(),
      anio: int.tryParse(_anio.text.trim()) ?? 0,
      poster: _poster.text.trim(),
      video: _video.text.trim(),
    );

    try {
      if (_esEdicion) {
        await _servicio.actualizarPelicula(pelicula);
      } else {
        await _servicio.crearPelicula(pelicula);
      }
      if (mounted) Navigator.pop(context, true); // true = hubo cambios
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar película' : 'Nueva película'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _campo(_titulo, 'Título'),
            _campo(_categoria, 'Categoría'),
            _campo(_descripcion, 'Descripción', lineas: 3),
            _campo(
              _anio,
              'Año',
              teclado: TextInputType.number,
              validador: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n < 1888 || n > 2100) {
                  return 'Ingresa un año válido';
                }
                return null;
              },
            ),
            _campo(_poster, 'URL del póster', teclado: TextInputType.url),
            _campo(_video, 'URL del video', teclado: TextInputType.url),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _guardando ? null : _guardar,
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(_esEdicion ? 'Actualizar' : 'Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(
    TextEditingController controller,
    String label, {
    int lineas = 1,
    TextInputType teclado = TextInputType.text,
    String? Function(String?)? validador,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: teclado,
        maxLines: lineas,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validador ??
            (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null,
      ),
    );
  }
}