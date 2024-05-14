import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veo_veo/domain/controllers/usuario_controller.dart';
import 'package:veo_veo/domain/entities/punto_de_interes.dart';

class Usuario {
  late String id;
  late String nombre;
  late String apellido;
  late String numeroTelefono;
  late String provincia;
  late String localidad;
  late String email;
  
  Usuario(this.id, this.nombre, this.apellido, this.numeroTelefono, this.provincia, this.localidad, this.email);
  Usuario.noInit();

  static Future<Usuario> fromId(String id) async {
      UsuarioController usuarioController = UsuarioController();
      DocumentSnapshot<Object?>? snapshot = await usuarioController.getUsuario(id);
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
      return Usuario('','','','','','', '');
    }


  }

  Stream<List<PuntoDeInteres>> obtenerLogrosUsuario(){
    UsuarioController usuarioController = UsuarioController();
    return usuarioController.obtenerLogrosUsuario(id);
  }

  Future<void> registrarLogro(punto) async {
    UsuarioController controller = UsuarioController();
    await controller.registrarLogro(id, punto);
  }

  
}