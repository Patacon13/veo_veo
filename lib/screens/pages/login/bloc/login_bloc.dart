import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veo_veo/providers/user_provider.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late UsuarioManager _userProvider;


  LoginBloc() : super(LoginInicial()) {
    on<LoginIniciado>(_onLoginIniciado);
    on<CodigoVerificacionIngresado>(_onCodigoVerificacionIngresado);
  }

  set userProvider(UsuarioManager provider){
    _userProvider = provider;
  }

Future<void> _onLoginIniciado(LoginIniciado event, Emitter<LoginState> emit) async {
    emit(Cargando());
    String telefono = event.nroTelefono;
    final completer = Completer<void>(); //esta para controlar que no termine el metodo, hasta que se complete el complete (se ejecute algun callback), si no da error con emit
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: telefono,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final user = await auth.signInWithCredential(credential);
            if (!completer.isCompleted) completer.complete();
            if(user.additionalUserInfo!.isNewUser){
                await _userProvider.registrar(user.user!.uid, telefono);
                emit(RegistroExitoso());
                close();
            } else {
              await _userProvider.loguear(user.user!.uid); 
              if(_userProvider.user!.regCompletado){
                emit(LoginExitoso());
                close();
              } else {
                emit(RegistroExitoso());
                close();
              }
            }
          } catch (e) {
            if (!completer.isCompleted) completer.complete();
            emit(ErrorOcurrido());
          }
        },
        verificationFailed: (FirebaseAuthException e) async {
          if (!completer.isCompleted) completer.complete();
          if (e.code == 'invalid-phone-number') {
            emit(NumeroInvalido());
          } else {
            emit(ErrorOcurrido());
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          if (!completer.isCompleted) completer.complete();
          emit(EsperandoCodigo(idVerificacion: verificationId, telefono: telefono));
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
        },
      );

      await completer.future;
    } catch (e) {
      if (!completer.isCompleted) completer.complete();
        emit(ErrorOcurrido());
    }
}


  Future<void> _onCodigoVerificacionIngresado(CodigoVerificacionIngresado event, Emitter<LoginState> emit) async {
    emit(Cargando());
    String codigoSMS = event.codigoSMS;
    String idVerificacion = event.idVerificacion;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: idVerificacion, smsCode: codigoSMS);
      final user = await auth.signInWithCredential(credential);
      if(user.additionalUserInfo!.isNewUser){
        await _userProvider.registrar(user.user!.uid, event.telefono);
        emit(RegistroExitoso());
        close();
      } else {
        await _userProvider.loguear(user.user!.uid); 
        if(_userProvider.user!.regCompletado){
          emit(LoginExitoso());
        } else {
          emit(RegistroExitoso());
          close();
        }
      }
    } catch (e) {
      emit(CodigoIncorrecto());
    }
  }




}
