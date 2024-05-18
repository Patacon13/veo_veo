// firestore_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/punto_de_interes.dart';


class PuntoDeInteresService {
  final CollectionReference puntosDeInteresColeccion= FirebaseFirestore.instance.collection('puntos_de_interes');

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
     throw Exception('Error al obtener punto de interes.');
  }
}


Future<List<DocumentSnapshot<Object?>>?> getPuntosDeInteres() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('puntos_de_interes')
        .get();
    return snapshot.docs;
  } catch (e) {
     throw Exception('Error al obtener todos los puntos de interes');
  }
}


}