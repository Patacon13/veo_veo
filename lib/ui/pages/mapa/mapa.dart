import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veo_veo/domain/controllers/punto_de_interes_controller.dart';
import 'package:veo_veo/ui/pages/scan_qr/scan_qr.dart';
import 'package:location/location.dart';
import 'dart:math' show asin, cos, min, sqrt;

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  late GoogleMapController mapController;
  Location location = Location();
  bool scannerEnabled = false; // Estado del botón de escáner QR
  List<LatLng> coordenadas = [];


  @override
  void initState() {
    super.initState();
    _obtenerUbicacionActual();
    _cargarCoordenadasPuntosDeInteres();
  }

  void _obtenerUbicacionActual() async {
    try {
      LocationData ubicacion = await location.getLocation();
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(ubicacion.latitude!, ubicacion.longitude!),
            zoom: 15.0,
          ),
        ),
      );

      double distanciaMinima = double.infinity;
      for (LatLng coordenada in coordenadas) {
        double distancia = _calcularDistancia(
          ubicacion.latitude!,
          ubicacion.longitude!,
          coordenada.latitude,
          coordenada.longitude,
        );
        distanciaMinima = min(distanciaMinima, distancia);
      }

      setState(() {
        scannerEnabled = distanciaMinima <= 0.05; //se habilita si está a menos e 50 metros
      });

    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> _cargarCoordenadasPuntosDeInteres() async {
    PuntoDeInteresController controller = new PuntoDeInteresController();
    List<DocumentSnapshot<Object?>>? documentos = await controller.getPuntosDeInteres();
    if (documentos != null) {
      List<LatLng> nuevasCoordenadas = [];
      for (var doc in documentos) {
        GeoPoint geoPoint = doc.get('ubicacion');
        LatLng latLng = LatLng(geoPoint.latitude, geoPoint.longitude);
        nuevasCoordenadas.add(latLng);
      }
      setState(() {
        coordenadas = nuevasCoordenadas;
        print(coordenadas);
      });
    }
  }

  double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(0.0, 0.0),
              zoom: 12.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: FloatingActionButton(
                onPressed: scannerEnabled
                    ? () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageCaptureScreen()));
                }
                    : null,
                child: const Icon(Icons.camera),
                backgroundColor:
                scannerEnabled ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
