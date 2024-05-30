import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/screens/pages/home/home.dart';
import 'package:veo_veo/screens/pages/scan/bloc/scan_bloc.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ScanBloc bloc = ScanBloc();
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    _initializeControllerFuture!.then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController!.takePicture();
      File imageFile = File(image.path);
      bloc.add(FotoEnviada(foto: imageFile));
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsuarioManager>(context, listen: false);
    bloc.userProvider = userProvider;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_cameraController!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  final currentState = bloc.state;
                  if (currentState is WidgetOculto || currentState is ScanInitial) {
                    _takePicture();
                  }
                },
                child: const Text('Tomar Foto'),
              ),
            ),
          ),
          BlocProvider(
        create: (context) => bloc,
        child: BlocListener<ScanBloc, ScanState>(
          listener: (context, state) {
            if (state is Redireccion) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(interfazInicial: 0)),
              );
            }
          },
          child: BlocBuilder<ScanBloc, ScanState>(
            builder: (context, scanState) {
                if (scanState is PuntoDetectado) {
                  return Center(child: _widgetDetectado(scanState));
                } else if (scanState is PuntoNoDetectado) {
                  return Center(child: _widgetNoDetectado());
                } else if (scanState is Cargando) {
                  return const Center(child: CircularProgressIndicator());
                } else if (scanState is ErrorDeteccion) {
                  return Center(child: _widgetErrorDeteccion());
                } else if (scanState is WidgetOculto) {
                  return Container();
              }
            return Container();
            },
          ),
        ),
          ),
        ],
      ),
    );
  }

  Widget _widgetDetectado(PuntoDetectado scanState) {
    return Padding(
      padding: const EdgeInsets.only(top: 420.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check, size: 48.0, color: Color.fromARGB(255, 92, 196, 96)),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${scanState.punto.nombre} detectado correctamente! :D. Redireccionando...',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green, fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetNoDetectado() {
    return const Padding(
      padding: EdgeInsets.only(top: 420.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.close, size: 48.0, color: Colors.red),
          SizedBox(height: 16.0),
          Text(
            'No se detectó ningún punto de interés :(',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget _widgetErrorDeteccion() {
    return const Padding(
      padding: EdgeInsets.only(top: 400.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.close, size: 48.0, color: Colors.red),
          SizedBox(height: 16.0),
          Text(
            'Ocurrio un error al procesar la imagen. :(',
            style: TextStyle(color: Colors.red, fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
