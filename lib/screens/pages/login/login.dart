//ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/screens/pages/home/home.dart';
import 'package:veo_veo/screens/pages/login/bloc/login_bloc.dart';
import 'package:veo_veo/screens/pages/login/verificacion.dart';
import 'package:veo_veo/screens/pages/perfil/perfil_config.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _telefono = '';
  final LoginBloc _bloc = LoginBloc();

  void _handleInputChanged(String value) {
    setState(() {
      _telefono = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc.userProvider = Provider.of<UsuarioManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is EsperandoCodigo) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerificacionPage(codigo: state.idVerificacion, bloc: _bloc, telefono: state.telefono)),
              );
            }
           if (state is LoginExitoso) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          else if (state is RegistroExitoso) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PerfilConfigPage()),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Bienvenido',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) => _handleInputChanged(value),
                      decoration: const InputDecoration(
                        labelText: 'Número de teléfono',
                        hintText: 'Introduzca su número',
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state is ErrorOcurrido) 
                      const Text(
                        'Ocurrió un error, intente más tarde',
                        style: TextStyle(color: Colors.red),
                      ),
                    if (state is NumeroInvalido)
                      const Text(
                        'Número de teléfono inválido',
                        style: TextStyle(color: Colors.red),
                      ),
                    if (state is Cargando)
                      const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _bloc.add(LoginIniciado(nroTelefono: _telefono));
                        },
                        child: const Text('Registrarse/Ingresar'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
