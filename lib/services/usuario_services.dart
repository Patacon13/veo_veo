//usuario_service.dart


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veo_veo/models/punto_de_interes.dart';
import '../models/usuario.dart';


class UsuarioService {
  final CollectionReference usuariosColeccion= FirebaseFirestore.instance.collection('usuarios');


  Future<void> agregarUsuario(Usuario usuario) async {
    try {
    await usuariosColeccion.add({
      'nombre': usuario.nombre,   
      'apellido': usuario.apellido,
      'telefono': usuario.numeroTelefono,
      'provincia': usuario.provincia,
      'localidad': usuario.localidad,
      'email': usuario.email,
       });
    } catch (e){
      throw Exception('Error al agregar usuario: $e');
    }
  }


Stream<List<PuntoDeInteres>> obtenerLogrosUsuario(String id) {
  return usuariosColeccion
      .doc(id) 
      .snapshots()
      .asyncMap((snapshot) async {
    try {
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
    } catch (e) {
      throw Exception('Error al obtener logros del usuario: $e');
    }
  });
}

Future<DocumentSnapshot<Object?>?> getUsuario(String id) async {
  try {
    DocumentSnapshot snapshot = await usuariosColeccion
        .doc(id)
        .get();
    return snapshot;
  } catch (e) {
      throw Exception('Error al obtener el usuario: $e');
  }
}

Future<bool> registrarLogro(String idUsuario, String idPuntoDeInteres) async {
    try {
      DocumentReference usuarioRef = usuariosColeccion.doc(idUsuario);
      DocumentReference puntoRef = FirebaseFirestore.instance.doc('/puntos_de_interes/$idPuntoDeInteres');
      await usuarioRef.update({
        'logros': FieldValue.arrayUnion([puntoRef]),
      });
        return true;
    } catch (e) {
      throw Exception('Error al registrar el logro: $e');
    }
  }

agregarUsuarioInicial(String uid) async {
  try {
    // Mapa con campos vacíos
    Map<String, dynamic> data = {
      'nombre': '',
      'apellido': '',
      'numeroTelefono': '',
      'provincia': '',
      'localidad': '',
      'email': '',
      'regCompletado': false,
    };
    await usuariosColeccion.doc(uid).set(data);
  } catch (e) {
    throw Exception('Error al agregar usuario: $e');
  }
}

  completarRegistro(Usuario? user) {}










  }