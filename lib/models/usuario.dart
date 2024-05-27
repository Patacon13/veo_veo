import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veo_veo/services/usuario_services.dart';
import 'package:veo_veo/models/punto_de_interes.dart';

class Usuario {
  static UsuarioService service = UsuarioService(); //Sacar de aca
  late String id;
  late String nombre;
  late String apellido;
  late String numeroTelefono;
  late String provincia;
  late String localidad;
  late String email;
  late bool regCompletado;
  late String urlPerfil;
  Usuario(this.id, this.nombre, this.apellido, this.numeroTelefono, this.provincia, this.localidad, this.email, this.regCompletado, this.urlPerfil);
  
  
  static Future<Usuario> fromId(String id) async {
      DocumentSnapshot<Object?>? snapshot = await service.getUsuario(id);
    if (snapshot != null && snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
       return fromJson(data);
    } else {
      throw Exception('Usuario no encontrado.');
    }
  }


    Map<String, dynamic> toJson() {
      final Map<String, dynamic> user = <String, dynamic>{};
      user["id"] = id;
      user["nombre"] = nombre;
      user["apellido"] = apellido;
      user["numeroTelefono"] = numeroTelefono;
      user["provincia"] = provincia;
      user["localidad"] = localidad;
      user["email"] = email;
      user["regCompletado"] = regCompletado;
      user["urlPerfil"] = urlPerfil;
      return user;
    }

  static Usuario fromJson(Map<String, dynamic> json) {
    return Usuario(
      json["id"] ?? '',
      json["nombre"] ?? '',
      json["apellido"] ?? '',
      json["numeroTelefono"] ?? '',
      json["provincia"] ?? '',
      json["localidad"] ?? '',
      json["email"] ?? '',
      json["regCompletado"] ?? false,
      json["urlPerfil"] ?? '',

    );
  }


  Stream<List<PuntoDeInteres>> obtenerLogrosUsuario(){
    return service.obtenerLogrosUsuario(id);
  }

  Future<bool> registrarLogro(punto) async {
    return await service.registrarLogro(id, punto);
  }

  static registrarInicial(String uid, String telefono) async {
    return await service.agregarUsuarioInicial(uid, telefono);
  }

  
}