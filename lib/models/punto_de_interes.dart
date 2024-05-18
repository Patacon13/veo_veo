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




static Future<PuntoDeInteres> fromId(String id) async {
DocumentSnapshot<Object?>? snapshot = await service.getPuntoDeInteres(id);
if (snapshot != null && snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      return fromSnaphost(snapshot);
    } else {
      throw Exception('Punto de interes no encontrado.');
    }
}

static PuntoDeInteres fromSnaphost(DocumentSnapshot snapshot){
  Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
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
