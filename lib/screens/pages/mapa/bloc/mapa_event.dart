part of 'mapa_bloc.dart';

sealed class MapaEvent {}
final class LocalizacionRequerida extends MapaEvent {
  late final GoogleMapController mapController;
  late final Location location;
  late final List<ll.LatLng> coordenadas;
  LocalizacionRequerida({required this.mapController, required this.coordenadas, required this.location});
}
final class LocalizacionPeriodicaRequerida extends MapaEvent {
  late final GoogleMapController mapController;
  late final Location location = Location();
  late final List<ll.LatLng> coordenadas;
  LocalizacionPeriodicaRequerida({required this.mapController, required this.coordenadas});
}


final class PuntosSolicitados extends MapaEvent{}
