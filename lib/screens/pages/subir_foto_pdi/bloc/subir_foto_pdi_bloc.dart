import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veo_veo/models/punto_de_interes.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/services/punto_de_interes_service.dart';

part 'subir_foto_pdi_event.dart';
part 'subir_foto_pdi_state.dart';

class SubirFotoPDIBloc extends Bloc<SubirFotoPDIEvent, SubirFotoPDIState>{

    late UsuarioManager _userProvider;
    final PuntoDeInteresService _service = PuntoDeInteresService();

  SubirFotoPDIBloc() : super(SubirFotoPDIInicial()) {
    on<FotoEnviada>(_onFotoEnviada);
  }  

  set userProvider(UsuarioManager userProvider) {
    _userProvider = userProvider;
  }  

  Future<FutureOr<void>> _onFotoEnviada(FotoEnviada event, Emitter<SubirFotoPDIState> emit) async {
    emit(Cargando());
    late String url;
    try{
      url = await _service.subirImagen(event.punto, event.imagen, _userProvider.user);
    } catch (e){
      emit(ErrorOcurrido());
    }
    if(url.isNotEmpty){
      emit(ImagenCargadaCorrectamente());
    } else {
      emit(ErrorOcurrido());
    }
  }
}