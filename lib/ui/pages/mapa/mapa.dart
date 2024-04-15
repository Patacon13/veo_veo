import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veo_veo/ui/pages/scan_qr/scan_qr.dart';
import 'package:location/location.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  late GoogleMapController mapController;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _obtenerUbicacionActual();
  }

  void _obtenerUbicacionActual() async {
    try {
      LocationData ubicacion = await location.getLocation();
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(ubicacion.latitude!, ubicacion.longitude!), // Centra el mapa en la ubicación actual
            zoom: 15.0,
          ),
        ),
      );
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScannerPage()),
                  );
                },
                child: const Icon(Icons.camera),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
