part of 'mapa_bloc.dart';


sealed class MapaState{}


class MapaInitial extends MapaState{}

class PuntosCargados extends MapaState{
    late List<LatLng> coordenadas;
    late LocationData posicionInicial;
    PuntosCargados({required this.coordenadas, required this.posicionInicial});
}

class ErrorOcurrido extends MapaState{}

class BotonHabilitado extends MapaState{}

class BotonDeshabilitado extends MapaState{}

class UbicacionCargada extends MapaState{
  late LocationData posicion;
  UbicacionCargada({required this.posicion});
}

class Cargando extends MapaState{}


