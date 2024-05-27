part of 'perfil_config_bloc.dart';



sealed class PerfilConfigEvent {}

final class DatosEnviados extends PerfilConfigEvent{
  late final Usuario usuario;
  late final File? foto;
  DatosEnviados({required this.usuario, required this.foto});
}

final class DatosPreviosRequeridos extends PerfilConfigEvent{}
