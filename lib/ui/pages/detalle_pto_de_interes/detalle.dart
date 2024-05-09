import 'package:flutter/material.dart';
import 'package:veo_veo/domain/entities/punto_de_interes.dart';

class DetallePage extends StatefulWidget {
  final PuntoDeInteres? detalle;
  DetallePage({Key? key, this.detalle}) : super(key: key);
  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle ' + (widget.detalle?.nombre ?? '')),
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
        SizedBox(height: 16),
        SizedBox(height: 8),
        Text(
          widget.detalle!.descripcion,
          style: TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
      )
    );
  }
}