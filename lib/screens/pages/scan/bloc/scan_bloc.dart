import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:veo_veo/models/punto_de_interes.dart';
import 'package:veo_veo/models/usuario.dart';

part 'scan_event.dart';
part 'scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial()) {
    on<FotoEnviada>(_onFotoEnviada);
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
            Usuario usuario = await Usuario.fromId("1");
            PuntoDeInteres puntoDeInteres = await PuntoDeInteres.fromId(punto);
            await usuario.registrarLogro(punto);
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

