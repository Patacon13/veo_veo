import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:veo_veo/services/usuario_services.dart';
import '../models/usuario.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';



class UsuarioManager extends ChangeNotifier {
  Usuario? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Usuario? get user => _user;

  Stream<User?> get usuarioStateChanges => _auth.authStateChanges();


  Future<void> loguear(String uid) async {
      _user = await Usuario.fromId(uid); //se debe llamar al service no al usuario
      await SessionManager().set("usuario", _user);
      notifyListeners();
  }

  Future<void> registrar(String uid) async {
      await Usuario.registrarInicial(uid);  //se debe llamar al service no al usuario
      loguear(uid);
  }

  Future<void> completarRegistro(Usuario rec) async {
    rec.id = _user!.id;
    await UsuarioService().completarRegistro(rec);
    await SessionManager().set("usuario", _user);
    await SessionManager().update();
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
