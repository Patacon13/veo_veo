part of 'subir_foto_pdi_bloc.dart';



sealed class SubirFotoPDIEvent {}

final class FotoEnviada extends SubirFotoPDIEvent{
  File? imagen;
  PuntoDeInteres punto;
  FotoEnviada({required this.imagen, required this.punto});
}



