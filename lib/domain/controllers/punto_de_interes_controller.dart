// firestore_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/punto_de_interes.dart';


class PuntoDeInteresController {
  final CollectionReference puntosDeInteresColeccion=
      FirebaseFirestore.instance.collection('puntos_de_interes');

  Future<void> agregarPunto(PuntoDeInteres puntoDeInteres) async {
    await puntosDeInteresColeccion.add({
      'nombre': puntoDeInteres.nombre    });
  }

Future<DocumentSnapshot<Object?>?> getPuntoDeInteres(String id) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('puntos_de_interes')
        .doc(id)
        .get();
    return snapshot;
  } catch (e) {
     return null;
  }
}


}