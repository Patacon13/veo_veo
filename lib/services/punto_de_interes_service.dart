// firestore_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/punto_de_interes.dart';


class PuntoDeInteresService {
  final CollectionReference puntosDeInteresColeccion= FirebaseFirestore.instance.collection('puntos_de_interes');


  Future<void> agregarPunto(PuntoDeInteres puntoDeInteres) async {
    await puntosDeInteresColeccion.add({
      'nombre': puntoDeInteres.nombre    });
  }

Future<PuntoDeInteres> getPuntoDeInteres(String id) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('puntos_de_interes')
        .doc(id)
        .get();
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      return PuntoDeInteres.fromJson(data);
    } else {
      throw Exception('Punto de interes no encontrado.');
    }
  } catch (e) {
     throw Exception('Error al obtener punto de interes.');
  }
}


Future<List<DocumentSnapshot<Object?>>?> getPuntosDeInteres() async { //deberia devolver una lista de punto de interes
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