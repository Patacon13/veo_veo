import 'package:veo_veo/services/usuario_services.dart';

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



  
}