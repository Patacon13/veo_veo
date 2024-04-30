import 'dart:async';
import 'package:rxdart/rxdart.dart';

class QRCheckerBloc {
  final _resultController = BehaviorSubject<bool>();
  Stream<bool> get resultStream => _resultController.stream;

  void dispose() {
    _resultController.close();
  }

  void changeQRText(bool isBridgeDetected) {
    print("Resultado");
    print(isBridgeDetected);
    _resultController.sink.add(isBridgeDetected);
  }
}