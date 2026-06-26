
class Pelicula {
  final int? id;
  final String titulo;
  final String categoria;
  final String descripcion;
  final int anio;
  final String poster;
  final String video;

  Pelicula({
    this.id,
    required this.titulo,
    required this.categoria,
    required this.descripcion,
    required this.anio,
    required this.poster,
    required this.video,
  });

  factory Pelicula.fromMap(Map<String, dynamic> map) {
    return Pelicula(
      id: map['id'] as int?,
      titulo: (map['titulo'] ?? '') as String,
      categoria: (map['categoria'] ?? '') as String,
      descripcion: (map['descripcion'] ?? '') as String,
      anio: (map['anio'] ?? 0) is int
          ? (map['anio'] ?? 0) as int
          : int.tryParse('${map['anio']}') ?? 0,
      poster: (map['poster'] ?? '') as String,
      video: (map['video'] ?? '') as String,
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'titulo': titulo,
      'categoria': categoria,
      'descripcion': descripcion,
      'anio': anio,
      'poster': poster,
      'video': video,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'categoria': categoria,
      'descripcion': descripcion,
      'anio': anio,
      'poster': poster,
      'video': video,
    };
  }
}