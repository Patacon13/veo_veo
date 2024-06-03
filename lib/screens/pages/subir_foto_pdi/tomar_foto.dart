// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class TomarFoto extends StatefulWidget {
  final CameraDescription camera;

  const TomarFoto({Key? key, required this.camera}) : super(key: key);

  @override
  _TomarFotoState createState() => _TomarFotoState();
}

class _TomarFotoState extends State<TomarFoto> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture(BuildContext context) async {
    try {
      await _initializeControllerFuture;
      final XFile picture = await _controller.takePicture();
      Navigator.pop(context, picture.path);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sacar Foto'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
floatingActionButton: FloatingActionButton(
  onPressed: () => _takePicture(context),
  child: const Icon(Icons.camera_alt),
),
floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
