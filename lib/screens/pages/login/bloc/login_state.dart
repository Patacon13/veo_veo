part of 'login_bloc.dart';



sealed class LoginState {}

final class LoginInicial extends LoginState{}

final class ErrorOcurrido extends LoginState{}

final class CodigoIncorrecto extends LoginState{}

final class NumeroInvalido extends LoginState{}

final class LoginExitoso extends LoginState{}

final class RegistroExitoso extends LoginState{}

final class Cargando extends LoginState{}

final class EsperandoCodigo extends LoginState{
  String idVerificacion;
  EsperandoCodigo({required this.idVerificacion});
}