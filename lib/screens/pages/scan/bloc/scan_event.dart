part of 'scan_bloc.dart';

sealed class ScanEvent {}
final class FotoEnviada extends ScanEvent {
  final File foto;
  FotoEnviada({required this.foto});
}

