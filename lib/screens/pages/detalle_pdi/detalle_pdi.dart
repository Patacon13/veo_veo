import 'package:flutter/material.dart';
import 'package:veo_veo/models/punto_de_interes.dart';
import 'package:veo_veo/screens/pages/detalle_pdi/widgets/carousel.dart';
import 'package:veo_veo/screens/pages/detalle_pdi/widgets/cuadricula.dart';
import 'package:veo_veo/services/punto_de_interes_service.dart';


class DetallePDIPage extends StatefulWidget {
  final PuntoDeInteres? detalle;

  DetallePDIPage({Key? key, this.detalle}) : super(key: key);

  @override
  _DetallePDIPageState createState() => _DetallePDIPageState();
}

class _DetallePDIPageState extends State<DetallePDIPage> {
  late Future<List<String>> _fotosRepositorio;
  late Future<List<String>> _fotosUsuarios;

  @override
  void initState() {
    super.initState();
    if (widget.detalle != null) {
      PuntoDeInteresService service = PuntoDeInteresService();
      _fotosRepositorio = service.obtenerFotosRepositorioPDI(widget.detalle!);
      _fotosUsuarios = service.obtenerFotosUsuariosPDI(widget.detalle!);
    }
  }

  void _abrirFoto(String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.network(url),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de ${widget.detalle?.nombre ?? ''}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            FutureBuilder<List<String>>(
              future: _fotosRepositorio,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar las fotos'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay fotos disponibles'));
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        RepositorioCarousel(
                          urls: snapshot.data!,
                          onImageTap: _abrirFoto,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.detalle!.descripcion,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const Text(
              "Imágenes subidas por los usuarios",
              style: TextStyle(
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<String>>(
              future: _fotosUsuarios,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar las fotos'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay fotos subidas por usuarios'));
                } else {
                  return Cuadricula(
                    urls: snapshot.data!,
                    onImageTap: _abrirFoto,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
