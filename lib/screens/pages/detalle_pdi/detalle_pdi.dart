import 'package:flutter/material.dart';
import 'package:veo_veo/models/punto_de_interes.dart';

class DetallePDIPage extends StatefulWidget {
  final PuntoDeInteres? detalle;
  DetallePDIPage({Key? key, this.detalle}) : super(key: key);
  @override
  _DetallePDIPageState createState() => _DetallePDIPageState();
}

class _DetallePDIPageState extends State<DetallePDIPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle ${widget.detalle?.nombre ?? ''}'),
      ),
      body:  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text((widget.detalle?.nombre ?? ''),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey[300],
          child: Image.network(widget.detalle!.portada, fit: BoxFit.cover),
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 8),
        Text(
          widget.detalle!.descripcion,
          style: const TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
      )
    );
  }
}