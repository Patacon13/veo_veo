import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veo_veo/screens/pages/login/bloc/login_bloc.dart';

class VerificacionPage extends StatefulWidget {
  final String codigo;
  final LoginBloc bloc;
  final String telefono;

  VerificacionPage({Key? key, required this.codigo, required this.bloc, required this.telefono}) : super(key: key);
  @override
  _VerificacionPageState createState() => _VerificacionPageState();
}

class _VerificacionPageState extends State<VerificacionPage> {
  List<String> _codigo = List.filled(6, '');

  void _handleInputChanged(String value, int index) {
    setState(() {
      _codigo[index] = value;
    });
  }

  @override
  void dispose() {
    widget.bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veo Veo'),
        automaticallyImplyLeading: false,
      ),
      body: BlocProvider(
        create: (context) => widget.bloc,
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Por favor, introduzca el código recibido por SMS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return _buildCodeDigitBox(index);
                      }),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          String codigoCompleto = _codigo.join();
                          widget.bloc.add(CodigoVerificacionIngresado(
                            codigoSMS: codigoCompleto,
                            idVerificacion: widget.codigo,
                            telefono: widget.telefono,
                          ));
                        },
                        child: const Text('Enviar'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state is Cargando) ...[
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ] else if (state is CodigoIncorrecto) ...[
                      const Center(
                        child: Text(
                          'El código ingresado es incorrecto. Proba nuevamente.',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ]
                  ],
                ),
              );
            },
          ),
        ),
    );
  }

  Widget _buildCodeDigitBox(int index) {
    return Container(
      width: 40,
      height: 50,
      alignment: Alignment.center,
      child: TextField(
        onChanged: (value) {
          if (value.length == 1) {
            _handleInputChanged(value, index);
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          }
        },
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        style: TextStyle(
          fontSize: 20,  // Tamaño de fuente reducido
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
