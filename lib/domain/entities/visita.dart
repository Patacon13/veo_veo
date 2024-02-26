import 'package:veo_veo/domain/entities/punto_de_interes.dart';
import 'package:veo_veo/domain/entities/usuario.dart';

class Visita {
  DateTime fecha;
  Usuario usuario;
  PuntoDeInteres puntoDeInteres;

  Visita(this.fecha, this.usuario, this.puntoDeInteres);
}