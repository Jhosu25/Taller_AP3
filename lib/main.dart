import 'package:flutter/material.dart';

import 'screens/CatalogoPeliculas.dart';

void main() {
  runApp(const PeliculasApp());
}

class PeliculasApp extends StatelessWidget {
  const PeliculasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatalogoPeliculas(),
    );
  }
}