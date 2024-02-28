import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../domain/blocs/qr_scanner_bloc.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String? result = '';
  bool isScanning = false;
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
        title: Text('Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: isScanning ? Colors.green : Colors.black,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                cameraFacing: CameraFacing.back,
              ),
            ),
          ),
          StreamBuilder<bool>(
            stream: _qrCheckerBloc.resultStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return Text(
                  'Resultado: QR correcto',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                );
              } else {
                return Text(
                  'Resultado: QR incorrecto',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isScanning = !isScanning;
            if (isScanning) {
              controller.resumeCamera();
            } else {
              controller.pauseCamera();
            }
          });
        },
        child: Icon(isScanning ? Icons.stop : Icons.play_arrow),
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
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _qrCheckerBloc.dispose();
    super.dispose();
  }
}
