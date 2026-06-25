import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/BienvenidaScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ihnnbtkfadbzpyfhcqnw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlobm5idGtmYWRienB5ZmhjcW53Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI0MTg1NzgsImV4cCI6MjA5Nzk5NDU3OH0.lJKPk0Xff7nNpRmYhRQOIcE53AaJxPOry6FEW_xhowY',
  );

  runApp(const PeliculasApp());
}

class PeliculasApp extends StatelessWidget {
  const PeliculasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BienvenidaScreen(),
    );
  }
}