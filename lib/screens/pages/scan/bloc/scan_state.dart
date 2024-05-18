part of 'scan_bloc.dart';

sealed class ScanState {}

final class ScanInitial extends ScanState {}

final class PuntoDetectado extends ScanState {
  final PuntoDeInteres punto;  
  PuntoDetectado({required this.punto});
}

final class PuntoNoDetectado extends ScanState {

}

final class ErrorDeteccion extends ScanState{

}

final class Cargando extends ScanState{}