// firestore_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veo_veo/domain/entities/punto_de_interes.dart';
import '../entities/usuario.dart';


class UsuarioController {
  final CollectionReference usuariosColeccion=
      FirebaseFirestore.instance.collection('usuarios');

  Future<void> agregarUsuario(Usuario usuario) async {
    await usuariosColeccion.add({
      'nombre': usuario.nombre,   
      'apellido': usuario.apellido,
      'telefono': usuario.numeroTelefono,
      'provincia': usuario.provincia,
      'localidad': usuario.localidad,
      'email': usuario.email,
       });
  }


Stream<List<PuntoDeInteres>> obtenerLogrosUsuario(String id) {
  return usuariosColeccion
      .doc(id) 
      .snapshots()
      .asyncMap((snapshot) async {
    if (snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      if (data.containsKey('logros') && data['logros'] is List) {
        List<DocumentReference> referencias = List<DocumentReference>.from(data['logros']);
        List<PuntoDeInteres> puntos = [];
        for (DocumentReference referencia in referencias) {
          DocumentSnapshot documento = await referencia.get();
          PuntoDeInteres puntoDeInteres = PuntoDeInteres.fromSnaphost(documento);
          puntos.add(puntoDeInteres);
        }
        return puntos;
      }
    }
    return [];
  });
}

Future<DocumentSnapshot<Object?>?> getUsuario(String id) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(id)
        .get();
    return snapshot;
  } catch (e) {
     return null;
  }
}

Future<void> registrarLogro(String idUsuario, String idPuntoDeInteres) async {
    try {
      DocumentReference userRef = FirebaseFirestore.instance.collection('usuarios').doc(idUsuario);
      DocumentReference pointOfInterestRef = FirebaseFirestore.instance.doc('/puntos_de_interes/$idPuntoDeInteres');
      await userRef.update({
        'logros': FieldValue.arrayUnion([pointOfInterestRef]),
      });
      print('Logro registrado con éxito para el usuario $idUsuario');
    } catch (e) {
      print('Error al registrar el logro: $e');
    }
  }


  }