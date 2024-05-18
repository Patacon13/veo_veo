import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veo_veo/services/usuario_services.dart';
import 'package:veo_veo/models/punto_de_interes.dart';

class Usuario {
  static UsuarioService service = UsuarioService();
  late String id;
  late String nombre;
  late String apellido;
  late String numeroTelefono;
  late String provincia;
  late String localidad;
  late String email;
  Usuario(this.id, this.nombre, this.apellido, this.numeroTelefono, this.provincia, this.localidad, this.email);
  
  
  static Future<Usuario> fromId(String id) async {
      DocumentSnapshot<Object?>? snapshot = await service.getUsuario(id);
    if (snapshot != null && snapshot.exists && snapshot.data() is Map<String, dynamic>) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
       return Usuario(
        snapshot.id,
        data['nombre'] ?? '',
        data['apellido'] ?? '',
        data['telefono'] ?? '',
        data['provincia'] ?? '',
        data['localidad'] ?? '',
        data['email'] ?? '',
      );
    } else {
      throw Exception('Usuario no encontrado.');
    }
  }

  Stream<List<PuntoDeInteres>> obtenerLogrosUsuario(){
    return service.obtenerLogrosUsuario(id);
  }

  Future<bool> registrarLogro(punto) async {
    return await service.registrarLogro(id, punto);
  }

  
}