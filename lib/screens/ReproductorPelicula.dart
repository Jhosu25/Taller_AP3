import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ReproductorPelicula extends StatefulWidget {
  final dynamic pelicula;
  const ReproductorPelicula({super.key, required this.pelicula});

  @override
  State<ReproductorPelicula> createState() => _ReproductorPeliculaState();
}

class _ReproductorPeliculaState extends State<ReproductorPelicula> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _inicializarReproductor();
  }

  // CARGA EL VIDEO DESDE LA URL DEL JSON Y CONFIGURA LOS CONTROLES
  Future<void> _inicializarReproductor() async {
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.pelicula['video']));

    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      // Controles estándar: reproducir, pausar, adelantar, retroceder, volumen
      allowPlaybackSpeedChanging: true,
      aspectRatio: _videoController.value.aspectRatio,
      placeholder: const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, errorMessage) =>
          Center(child: Text(errorMessage)),
    );

    setState(() {});
  }

  @override
  void dispose() {
    // Liberar recursos al salir de la pantalla
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pelicula;

    return Scaffold(
      appBar: AppBar(title: Text(p['titulo'])),
      body: Column(
        children: [
          // REPRODUCTOR DE VÍDEO
          AspectRatio(
            aspectRatio: _videoController.value.isInitialized
                ? _videoController.value.aspectRatio
                : 16 / 9,
            child: _chewieController != null &&
                    _videoController.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 12),
          // INFORMACIÓN DE LA PELÍCULA
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['titulo'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text("${p['categoria']}  •  ${p['anio']}"),
                const SizedBox(height: 8),
                Text(p['descripcion']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
