import 'package:latlong2/latlong.dart';

import 'descripcion.dart';

class PuntoDeInteres {
  LatLng ubicacion;
  String nombre;
  String qr;
  Descripcion descripcion;
  PuntoDeInteres(this.ubicacion, this.nombre, this.qr, this.descripcion);
}