import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetallePage extends StatefulWidget {
  final String? detalle;
  DetallePage({Key? key, this.detalle}) : super(key: key);
  @override
  _DetallePageState createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle ' + (widget.detalle ?? '')),
      ),
      body:  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text((widget.detalle ?? ''),
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
          // child: Image.asset('assets/puente.jpg', fit: BoxFit.cover),
        ),
        SizedBox(height: 16),
        Text(
          'Descripción del Punto Turístico',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),
        const Text(
          'Descripción detallada del punto turístico, incluyendo historia, características y cualquier otra información relevante.',
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