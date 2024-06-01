part of 'login_bloc.dart';



sealed class LoginEvent {}

final class LoginIniciado extends LoginEvent{
  late final String nroTelefono;
  LoginIniciado({required this.nroTelefono});
}

final class CodigoVerificacionIngresado extends LoginEvent{
  late final String codigoSMS;
  late final String idVerificacion;
  late final String telefono;
  CodigoVerificacionIngresado({required this.codigoSMS, required this.idVerificacion, required this.telefono});
}

final class LoginReestablecido extends LoginEvent{

}
