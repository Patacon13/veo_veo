import 'package:veo_veo/domain/entities/visita.dart';

class Usuario {
  String nombre;
  String apellido;
  String numeroTelefono;
  String provincia;
  String localidad;
  late List<Visita> visitas;

  Usuario(this.nombre, this.apellido, this.numeroTelefono, this.provincia, this.localidad);
}