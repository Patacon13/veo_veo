//ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_pickers/country.dart';
import 'package:veo_veo/screens/pages/home/home.dart';
import 'package:veo_veo/screens/pages/login/bloc/login_bloc.dart';
import 'package:veo_veo/screens/pages/login/verificacion.dart';
import 'package:veo_veo/screens/pages/perfil/perfil_config.dart';

import 'widgets/country_picker_widget.dart';

class LoginPage extends StatefulWidget with WidgetsBindingObserver {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _telefono = '', _codigoPais = '+54', _area = '';

  void _handleInputChanged(String value) {
    setState(() {
      _telefono = value;
    });
  }
  void _handleAreaChanged(String value) {
    setState(() {
      _area = value;
    });
  }
  void _handleCountrySelected(Country country) {
    setState(() {
      _codigoPais = '+${country.phoneCode}';
    });
    print('País seleccionado: ${country.name}, Código: ${country.phoneCode}');
  }
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
      final LoginBloc _bloc = BlocProvider.of<LoginBloc>(context);
      return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,  
      ),
      body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is EsperandoCodigo) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VerificacionPage(codigo: state.idVerificacion, telefono: state.telefono)),
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
                    Row(
                      children: [
                        CountryPickerWidget(
                          onCountrySelected: _handleCountrySelected,
                        ), // Country picker widget
                        SizedBox(width: 8), // Spacer between country picker and text field
                        Expanded(
                          flex: 1,
                          child: TextField(
                            onChanged: (value) => _handleAreaChanged(value),
                            decoration: const InputDecoration(
                              labelText: 'Area',
                              hintText: 'Area',
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            onChanged: (value) => _handleInputChanged(value),
                           decoration: const InputDecoration(
                              labelText: 'Número de teléfono',
                              hintText: 'Introduzca su número',
                            ),
                          ),
                        ),
                      ],
                    ), //row
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
                          _bloc.add(LoginIniciado(nroTelefono: _codigoPais + _area + _telefono));
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
    );
  }

  
}

