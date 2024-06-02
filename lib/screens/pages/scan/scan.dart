import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/screens/pages/scan/bloc/scan_bloc.dart';
import 'package:veo_veo/screens/pages/subir_foto_pdi/subir_foto_pdi.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with TickerProviderStateMixin {
  late ScanBloc bloc;
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  
  late AnimationController _recuadroAnimationController;
  late AnimationController _iconoAnimationController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    bloc = ScanBloc();
    _initializeCamera();

    _recuadroAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _iconoAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
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
    _recuadroAnimationController.dispose();
    _iconoAnimationController.dispose();
    _fadeController.dispose();
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
                return Positioned.fill(
                  child: CameraPreview(_cameraController!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 150,
              child: CustomPaint(
                painter: BorderPainter(_recuadroAnimationController),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                    MaterialPageRoute(builder: (context) => SubirFotoPDIPage(punto: state.punto)),
                  );
                }
              },
              child: BlocBuilder<ScanBloc, ScanState>(
                builder: (context, scanState) {
                  if (scanState is PuntoDetectado) {
                    _recuadroAnimationController.reset();
                    _iconoAnimationController.reset();
                    _fadeController.reset();
                    _recuadroAnimationController.forward().whenComplete(() {
                      _iconoAnimationController.forward().whenComplete(() {
                        _fadeController.forward();
                      });
                    });
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
    return FadeTransition(
      opacity: _fadeController,
      child: AnimatedBuilder(
        animation: _iconoAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(
                parent: _iconoAnimationController,
                curve: Curves.elasticOut,
              ),
            ).value,
            child: Transform.rotate(
              angle: Tween<double>(begin: -0.5, end: 0.0).animate(
                CurvedAnimation(
                  parent: _iconoAnimationController,
                  curve: Curves.elasticOut,
                ),
              ).value,
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.check, size: 96.0, color: Colors.blue),
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${scanState.punto.nombre} detectado correctamente!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ElegantFont',
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            'No se detectó nada. Probá de nuevo :(',
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
            'Ocurrio un error al detectar el punto. :(',
            style: TextStyle(color: Colors.red, fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final Animation<double> animation;

  BorderPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    double progress = animation.value * 4;

    if (progress < 1) {
      path.moveTo(progress * size.width, 0);
      path.lineTo(0, 0);
    } else if (progress < 2) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, (progress - 1) * size.height);
    } else if (progress < 3) {
      path.moveTo(size.width, size.height);
      path.lineTo(size.width - (progress - 2) * size.width, size.height);
    } 

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
