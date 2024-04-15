import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:veo_veo/ui/pages/detalle_pto_de_interes/detalle.dart';
import 'package:veo_veo/ui/pages/login/login.dart';
import '../../../domain/blocs/qr_scanner_bloc.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String? result = '';
  bool isScanning = true;
  late QRCheckerBloc _qrCheckerBloc;

  @override
  void initState() {
    super.initState();
    _qrCheckerBloc = QRCheckerBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear QR'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            cameraFacing: CameraFacing.back,
          ),
          Center(
            child: Container(
              width: 200, // Ancho del cuadro blanco
              height: 200, // Alto del cuadro blanco
              decoration: BoxDecoration(
                border: isScanning? Border.all(color: Colors.white, width: 2.0) : Border.all(color: Colors.green, width: 2.0), // Borde blanco
                borderRadius: BorderRadius.circular(10.0), // Borde redondeado
                color: Colors.transparent, // Cambio de color
              ),
            ),
          ),

        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
        isScanning = false;
        controller.pauseCamera();
        _qrCheckerBloc.changeQRText(result!);
      });
      _qrCheckerBloc.resultStream.listen((isValid) {
        if (!isValid) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('El código QR no es válido.'),
          ));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetallePage(detalle: 'Molino')),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _qrCheckerBloc.dispose();
    super.dispose();
  }
}
