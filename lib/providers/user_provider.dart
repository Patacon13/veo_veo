import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veo_veo/services/usuario_services.dart';
import '../models/usuario.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';



class UsuarioManager extends ChangeNotifier {
  Usuario? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Usuario? get user => _user;
  User? get firestoreUser => _auth.currentUser;
  UsuarioService service = UsuarioService();
  Stream<User?> get usuarioStateChanges => _auth.authStateChanges();


  Future<void> loguear(String uid) async {
      _user = await service.getUsuario(uid); 
      await SessionManager().set("usuario", _user);
      notifyListeners();
  }

  Future<void> registrar(String uid, String telefono) async {
      await service.agregarUsuarioInicial(uid, telefono); 
      loguear(uid);
  }

  Future<void> completarRegistro(Usuario rec, File? image) async {
    rec.id = _user!.id;
    rec.numeroTelefono = _user!.numeroTelefono;
    if(image != null){
        String url = await actualizarFotoPerfil(image);
        rec.urlPerfil = url;
    } else {
        rec.urlPerfil = _user!.urlPerfil; 
    }
    await service.completarRegistro(rec);
    _user = rec;
    await SessionManager().set("usuario", rec);
    await SessionManager().update();
    notifyListeners();
  }

  Future<String> actualizarFotoPerfil(File imagen){
    return service.actualizarFotoPerfil(imagen, _user!.id);
  }

  Future<bool> crearSesion() async {
    if(await SessionManager().containsKey("usuario")){
      _user = Usuario.fromJson(await SessionManager().get("usuario"));
      return true;
    } else {
      return false;
    }
  }

  Future<void> signout() async {
    _user = null;
    await SessionManager().destroy();
    notifyListeners();
  }
}
