import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veo_veo/screens/pages/mapa/bloc/mapa_bloc.dart';
import 'package:veo_veo/screens/pages/scan/scan.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  late MapaBloc bloc;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    bloc = MapaBloc();
    bloc.add(PuntosSolicitados());
  }

  @override
  void dispose() {
    mapController?.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext contextPrincipal) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<MapaState>(
            stream: bloc.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final mapaState = snapshot.data!;
                if (mapaState is PuntosCargados || mapaState is BotonHabilitado || mapaState is BotonDeshabilitado) {
                  LatLng target = mapaState is PuntosCargados
                      ? LatLng(mapaState.posicionInicial.latitude!, mapaState.posicionInicial.longitude!)
                      : LatLng(0, 0); 
                  return GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                      if (mapaState is PuntosCargados) {
                        bloc.add(LocalizacionPeriodicaRequerida(
                          mapController: mapController!,
                          coordenadas: mapaState.coordenadas,
                        ));
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target: target,
                      zoom: 16.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  );
                } else if (mapaState is Cargando) {
                  return const Center(child: CircularProgressIndicator());
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          StreamBuilder<MapaState>(
            stream: bloc.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final mapaState = snapshot.data!;
                if (mapaState is BotonHabilitado) {
                  return _buildFloatingActionButton(contextPrincipal, Colors.blue, true);
                } else if (mapaState is BotonDeshabilitado) {
                  return _buildFloatingActionButton(contextPrincipal, Colors.grey, false);
                }
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Positioned _buildFloatingActionButton(BuildContext context, Color color, bool habilitado) {
    return Positioned(
      bottom: 16.0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: FloatingActionButton(
          onPressed: habilitado ? () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ScanPage()));
          } : null,
          backgroundColor: color,
          child: const Icon(Icons.camera),
        ),
      ),
    );
  }
}
