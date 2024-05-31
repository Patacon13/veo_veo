part of 'subir_foto_pdi_bloc.dart';



sealed class SubirFotoPDIState {}

final class SubirFotoPDIInicial extends SubirFotoPDIState{}

final class Cargando extends SubirFotoPDIState{}

final class ImagenCargadaCorrectamente extends SubirFotoPDIState{}

final class ErrorOcurrido extends SubirFotoPDIState{

}


