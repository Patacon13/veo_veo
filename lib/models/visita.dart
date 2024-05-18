import 'package:veo_veo/models/punto_de_interes.dart';
import 'package:veo_veo/models/usuario.dart';

class Visita {
  DateTime fecha;
  Usuario usuario;
  PuntoDeInteres puntoDeInteres;

  Visita(this.fecha, this.usuario, this.puntoDeInteres);
}