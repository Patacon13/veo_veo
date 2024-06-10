part of 'perfil_config_bloc.dart';



sealed class PerfilConfigState {}

final class PerfilConfigInicial extends PerfilConfigState{}

final class DatosPreviosCargados extends PerfilConfigState{
  late final Usuario? usuario;
  late final String? tyc;
  DatosPreviosCargados({required this.usuario, this.tyc});
}

final class Cargando extends PerfilConfigState{}

final class DatosCargadosCorrectamente extends PerfilConfigState{}

final class ErrorOcurrido extends PerfilConfigState{}


