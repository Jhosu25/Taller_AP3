import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taller_1_am3/data/Pelicula.dart';


class PeliculasService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tabla = 'peliculas';


  Future<List<Pelicula>> obtenerPeliculas() async {
    final List<dynamic> datos = await _supabase
        .from(_tabla)
        .select()
        .order('anio', ascending: false);

    return datos
        .map((fila) => Pelicula.fromMap(fila as Map<String, dynamic>))
        .toList();
  }

  Future<Pelicula> crearPelicula(Pelicula pelicula) async {
    final List<dynamic> respuesta = await _supabase
        .from(_tabla)
        .insert(pelicula.toInsertMap())
        .select();

    return Pelicula.fromMap(respuesta.first as Map<String, dynamic>);
  }

  Future<Pelicula> actualizarPelicula(Pelicula pelicula) async {
    final List<dynamic> respuesta = await _supabase
        .from(_tabla)
        .update(pelicula.toInsertMap())
        .eq('id', pelicula.id as Object)
        .select();

    return Pelicula.fromMap(respuesta.first as Map<String, dynamic>);
  }

  Future<void> eliminarPelicula(int id) async {
    await _supabase.from(_tabla).delete().eq('id', id);
  }
}