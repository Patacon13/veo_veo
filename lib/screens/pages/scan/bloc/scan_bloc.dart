import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:veo_veo/models/punto_de_interes.dart';
import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/services/punto_de_interes_service.dart';
import 'package:veo_veo/services/usuario_services.dart';
part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  UsuarioService usuarioService = UsuarioService();
  PuntoDeInteresService puntoService = PuntoDeInteresService();
  late UsuarioManager _userProvider;
  ScanBloc() : super(ScanInitial()) {
    on<FotoEnviada>(_onFotoEnviada);
  }

  set userProvider(UsuarioManager userProvider) {
      _userProvider = userProvider;
  }  

  Future<FutureOr<void>> _onFotoEnviada(FotoEnviada event, Emitter<ScanState> emit) async {
     emit(Cargando());
     try {
     Response respuesta = await compararImagen(event.foto);
      if(respuesta.statusCode != 200){
          emit(ErrorDeteccion());
      } else {
          final respuestaJson= json.decode(respuesta.body);
          dynamic coincidencia = respuestaJson['coincidencia'];
          dynamic punto = respuestaJson['punto'];
          if(coincidencia > 0.05){
            Usuario? usuario = _userProvider.user;
            PuntoDeInteres puntoDeInteres = await puntoService.getPuntoDeInteres(punto);
            await usuarioService.registrarLogro(usuario!.id, punto);
            emit(PuntoDetectado(punto: puntoDeInteres));
          } else {
            emit(PuntoNoDetectado());
          }
      }
     } catch(e){
      emit(ErrorDeteccion());
     }
  }


  Future<Response> compararImagen(File imagen) async {
    const url = 'http://192.168.100.4:5000/procesar';
    String base64Image = base64Encode(imagen.readAsBytesSync());
      final response = await post(Uri.parse(url), body: {
      'imagen': 'data:image/jpeg;base64,$base64Image',
      });
    return response;
  }

}

