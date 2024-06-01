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
  String _codigo = '';

  void _handleInputChanged(String value) {
    setState(() {
      _codigo = value;
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
                  children: <Widget>[
                    const Text(
                      'Por favor, introduzca el código recibido por SMS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: _handleInputChanged,
                      decoration: const InputDecoration(
                        labelText: 'Código',
                        hintText: 'Introduzca el código',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.bloc.add(CodigoVerificacionIngresado(
                            codigoSMS: _codigo,
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
}
