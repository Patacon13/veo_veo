import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/services/usuario_services.dart';

part 'perfil_config_event.dart';
part 'perfil_config_state.dart';

class PerfilConfigBloc extends Bloc<PerfilConfigEvent, PerfilConfigState>{

  late UsuarioManager _userProvider;

  PerfilConfigBloc() : super(PerfilConfigInicial()) {
    on<DatosEnviados>(_onDatosEnviados);
    on<DatosPreviosRequeridos>(_onDatosPreviosRequeridos);
  }

  set userProvider(UsuarioManager userProvider) {
    _userProvider = userProvider;
  }  

  Future<FutureOr<void>> _onDatosEnviados(DatosEnviados event, Emitter<PerfilConfigState> emit) async {
    emit(Cargando());
    Usuario user = event.usuario;
    File? imagen = event.foto;
    try{
      await _userProvider.completarRegistro(user, imagen);
      emit(DatosCargadosCorrectamente());
    } catch(e) {
      emit(ErrorOcurrido());
    }
  }

  FutureOr<void> _onDatosPreviosRequeridos(DatosPreviosRequeridos event, Emitter<PerfilConfigState> emit) async {
    emit(Cargando());
    Usuario? actual  = _userProvider.user;
    if(!event.tycReq){
      emit(DatosPreviosCargados(usuario: actual));
    } else {
      String tycContenido = await UsuarioService().obtenerTyC();
      emit(DatosPreviosCargados(usuario: actual, tyc: tycContenido));
    }
  }
}