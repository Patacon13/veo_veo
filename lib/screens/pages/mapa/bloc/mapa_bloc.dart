import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:veo_veo/models/punto_de_interes.dart';
import 'package:veo_veo/services/punto_de_interes_service.dart';
part 'mapa_event.dart';
part 'mapa_state.dart';


class MapaBloc extends Bloc<MapaEvent, MapaState> {
    Timer? _timerUbicacion;
  MapaBloc() : super(MapaInitial()) {
    on<PuntosSolicitados>(_onPuntosSolicitados);
    on<LocalizacionRequerida>(_onLocalizacionRequerida);
    on<LocalizacionPeriodicaRequerida>(_onLocalizacionPeriodicaRequerida);
  }
  
  Future<FutureOr<void>> _onLocalizacionRequerida(LocalizacionRequerida event, Emitter<MapaState> emit) async {
       try {
      LocationData ubicacion = await event.location.getLocation();      
      double distanciaMinima = double.infinity;
      for (LatLng coordenada in event.coordenadas) {
        double distancia = _calcularDistancia(
          ubicacion.latitude!,
          ubicacion.longitude!,
          coordenada.latitude,
          coordenada.longitude,
        );
        distanciaMinima = min(distanciaMinima, distancia);
      }
    if(distanciaMinima <= 0.05){
      emit(BotonHabilitado());
    } else {
      emit(BotonDeshabilitado());
    } 
    } catch (e) {
      emit(ErrorOcurrido());
    }
  }

  double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }



  Future<FutureOr<void>> _onPuntosSolicitados(PuntosSolicitados event, Emitter<MapaState> emit) async {
    emit(Cargando());
    PuntoDeInteresService controller = PuntoDeInteresService();
    List<PuntoDeInteres> puntos = await controller.getPuntosDeInteres();
    List<LatLng> nuevasCoordenadas = [];
      for (var punto in puntos) {
        nuevasCoordenadas.add(punto.ubicacion as LatLng);
      }
    LocationData ubicacion = await Location().getLocation();
    emit(PuntosCargados(coordenadas: nuevasCoordenadas, posicionInicial: ubicacion));
  }


  FutureOr<void> _onLocalizacionPeriodicaRequerida(LocalizacionPeriodicaRequerida event, Emitter<MapaState> emit) {
    _timerUbicacion?.cancel();
    _timerUbicacion = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(LocalizacionRequerida(
        mapController: event.mapController,
        coordenadas: event.coordenadas,
        location: event.location
      ));
    });
  }
}


