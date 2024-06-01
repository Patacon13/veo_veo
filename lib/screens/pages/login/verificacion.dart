import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veo_veo/screens/pages/login/bloc/login_bloc.dart';

class VerificacionPage extends StatefulWidget {
  final String codigo;
  final String telefono;

  VerificacionPage({Key? key, required this.codigo, required this.telefono}) : super(key: key);
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

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Estas seguro?'),
          content: const Text('Si vas para atrás, se va a cancelar el login/registro y vas a tener que volver a empezar. ¿Deseas continuar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                BlocProvider.of<LoginBloc>(context).add(LoginReestablecido());
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginBloc bloc = BlocProvider.of<LoginBloc>(context);
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Veo Veo'),
          automaticallyImplyLeading: false,
        ),
        body:  BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Enviamos un mensaje de texto con el código al número ${widget.telefono}. Ingresalo acá.",
                      style: const TextStyle(
                        fontSize: 22,
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
                          bloc.add(CodigoVerificacionIngresado(
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
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        style: const TextStyle(
          fontSize: 20,  // Tamaño de fuente reducido
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
