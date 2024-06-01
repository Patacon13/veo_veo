import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:veo_veo/models/usuario.dart';
import '../models/punto_de_interes.dart';


class PuntoDeInteresService {
  final CollectionReference puntosDeInteresColeccion= FirebaseFirestore.instance.collection('puntos_de_interes');
  final storageRef = FirebaseStorage.instance.ref();

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


  Future<List<PuntoDeInteres>> getPuntosDeInteres() async { 
    List<PuntoDeInteres> lista = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('puntos_de_interes')
          .get();
      for (var element in snapshot.docs) {
        lista.add(PuntoDeInteres.fromJson(element.data() as Map<String, dynamic>));
      }
    } catch (e) {
      throw Exception('Error al obtener todos los puntos de interes');
    }
    return lista;
  }

  Future<String> subirImagen(PuntoDeInteres punto, File? imagen, Usuario? user) async {
    final link = storageRef.child("subidas/${punto.id}_${user!.id}.jpg");
    final tareaSubir = link.putFile(imagen!);
    await tareaSubir.whenComplete(() => null); 
    final url = await link.getDownloadURL(); 
    return url; 
  } 

Future<List<String>> obtenerFotosUsuariosPDI(PuntoDeInteres punto) async {
  List<String> lista = [];
    final directorio = storageRef.child('subidas/');
    final resultado = await directorio.listAll();
    final fotosPunto = resultado.items.where((item) => item.name.startsWith('${punto.id}_'));
    for (var item in fotosPunto) {
      final url = await item.getDownloadURL();
      lista.add(url);
    }
  return lista;
}

Future<List<String>> obtenerFotosRepositorioPDI(PuntoDeInteres punto) async {
  List<String> lista = [];
    final directorio = storageRef.child('repositorio/');
    final resultado = await directorio.listAll();
    final fotosPunto = resultado.items.where((item) => item.name.startsWith('${punto.id}_'));
    for (var item in fotosPunto) {
      final url = await item.getDownloadURL();
      lista.add(url);
    }
  return lista;
}

}