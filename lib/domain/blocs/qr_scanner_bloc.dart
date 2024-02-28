import 'dart:async';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class QRCheckerBloc {
  final _qrTextController = BehaviorSubject<String>();
  Stream<String> get qrTextStream => _qrTextController.stream;
  Function(String) get changeQRText => _qrTextController.sink.add;

  final _resultController = BehaviorSubject<bool>();
  Stream<bool> get resultStream => _resultController.stream;

  QRCheckerBloc() {
    _qrTextController.stream.listen(_checkQRText);
  }

  void dispose() {
    _qrTextController.close();
    _resultController.close();
  }

  void _checkQRText(String qrText) {
    if (qrText == "http://hola.com") {
      _resultController.sink.add(true);
    } else {
      _resultController.sink.add(false);
    }
  }
}
