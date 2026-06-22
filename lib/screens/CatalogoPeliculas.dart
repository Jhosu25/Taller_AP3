import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ReproductorPelicula.dart';

class CatalogoPeliculas extends StatefulWidget {
  const CatalogoPeliculas({super.key});

  @override
  State<CatalogoPeliculas> createState() => _CatalogoPeliculasState();
}

class _CatalogoPeliculasState extends State<CatalogoPeliculas> {
  // Sube el archivo assets/peliculas.json a GitHub Pages (igual que el profesor)
  // y reemplaza esta URL por la tuya. Ej: https://TUUSUARIO.github.io/web-api/peliculas.json
  final String url = "https://jritsqmet.github.io/web-api/peliculas.json";

  // FUNCIÓN QUE LEE EL JSON DESDE LA URL
  Future<List<dynamic>> leerURL() async {
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode != 200) {
        throw Exception("HTTP ${respuesta.statusCode}: ${respuesta.reasonPhrase}");
      }
      return json.decode(respuesta.body);
    } catch (e) {
      throw Exception("No se pudo cargar el catálogo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Catálogo de Películas")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Películas disponibles",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: leerURL(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return ListTile(
                        leading: Image.network(
                          item['poster'],
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item['titulo']),
                        subtitle: Text(
                            "${item['categoria']}  •  ${item['descripcion']}"),
                        // Al tocar la fila se muestra más información
                        onTap: () => verMas(context, item),
                        // TRAILING con un botón que reproduce la película
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle_fill),
                          onPressed: () => reproducir(context, item),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Cargando catálogo..."),
                      CircularProgressIndicator(),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// MUESTRA MÁS INFORMACIÓN DE LA PELÍCULA
void verMas(BuildContext context, dynamic p) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(p['titulo']),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(p['poster']),
          const SizedBox(height: 8),
          Text("Categoría: ${p['categoria']}"),
          Text("Año: ${p['anio']}"),
          const Divider(),
          Text(p['descripcion']),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cerrar"),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            reproducir(context, p);
          },
          child: const Text("Reproducir"),
        ),
      ],
    ),
  );
}

// NAVEGA A LA PANTALLA DE REPRODUCCIÓN
void reproducir(BuildContext context, dynamic p) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ReproductorPelicula(pelicula: p),
    ),
  );
}
