import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:veo_veo/services/punto_de_interes_service.dart';


class PuntoDeInteres {
  late String nombre;
  late String id;
  late LatLng ubicacion;
  late String portada;
  late String descripcion;
  static PuntoDeInteresService service = PuntoDeInteresService();

  PuntoDeInteres(this.id, this.nombre);
  PuntoDeInteres.completo(this.id, this.nombre, this.ubicacion, this.portada, this.descripcion);



static PuntoDeInteres fromJson(Map<String, dynamic> data){
  GeoPoint ubicacion = data['ubicacion'];
 return PuntoDeInteres.completo(
        data['id'].toString(),
        data['nombre'].toString(),
        LatLng(ubicacion.latitude, ubicacion.longitude),
        data['enlace'].toString(),
        data['descripcion'].toString()
      );
}



}
