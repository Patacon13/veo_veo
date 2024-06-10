import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/screens/pages/home/home.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:veo_veo/screens/pages/perfil/bloc/perfil_config_bloc.dart';

class PerfilConfigPage extends StatefulWidget {
  final bool volverAtras;
  PerfilConfigPage({Key? key, this.volverAtras = false}) : super(key: key);

  @override
  _PerfilConfigPageState createState() => _PerfilConfigPageState();
}

class _PerfilConfigPageState extends State<PerfilConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  late String? _tycContenido;
  final _apellidoController = TextEditingController();
  final _ciudadController = TextEditingController();
  PerfilConfigBloc bloc = PerfilConfigBloc();
  File? _image;
  bool _terminosAceptados = false;
  

  @override
  void initState() {
    super.initState();
    bloc.add(DatosPreviosRequeridos(tycReq: terminosRequeridos()));
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && (!terminosRequeridos() || _terminosAceptados)) {
      final nombre = _nombreController.text;
      final apellido = _apellidoController.text;
      final ciudad = _ciudadController.text;
      Usuario rec = Usuario('', nombre, apellido, '', '', ciudad, '', true, "");
      bloc.add(DatosEnviados(usuario: rec, foto: _image));
    } else if (terminosRequeridos() && !_terminosAceptados) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debes aceptar los términos y condiciones para continuar')),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (!widget.volverAtras) {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Completa el registro.'),
            content: const Text('Por favor, completa el registro antes de salir.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      ) ?? false;
    } else {
      return true;
    }
  }

  bool terminosRequeridos() {
    return !widget.volverAtras;
  }

  void _mostrarTerminosYCondiciones() async {
    if(_tycContenido != null && _tycContenido!.isNotEmpty) {
      _buildTyCDialog(_tycContenido!);
    } else {
      _buildTyCDialog('No se pudo cargar el contenido de los Términos y Condiciones.');
    }
  }

void _buildTyCDialog(String tycContent) {
  bool hasScrolledToEnd = false;
  ScrollController _scrollController = ScrollController();
  bool eleccion = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              setState(() {
                hasScrolledToEnd = true;
              });
            }
          });

          return AlertDialog(
            title: const Text('Términos y Condiciones'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.99, 
              height: MediaQuery.of(context).size.height * 0.7, 
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Html(data: utf8.decode(tycContent.runes.toList())), // Decodifica el contenido con UTF-8
              ),
            ),
            actions: [
              TextButton(
                onPressed: hasScrolledToEnd
                    ? () {
                        eleccion = true;
                        Navigator.of(context).pop(true);
                      }
                    : null,
                child: const Text('Aceptar'),
              ),
              TextButton(
                onPressed: () {
                  eleccion = false;
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    },
  ).then((_) { 
    setState(() {
      _terminosAceptados = eleccion;
    });
  });
}


  @override
  Widget build(BuildContext context) {
    bloc.userProvider = Provider.of<UsuarioManager>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const Text('Configurar Perfil'),
          automaticallyImplyLeading: widget.volverAtras,
        ),
        body: BlocProvider(
          create: (context) => bloc,
          child: BlocListener<PerfilConfigBloc, PerfilConfigState>(
            listener: (context, state) {
              if (state is DatosCargadosCorrectamente) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(interfazInicial: 2),
                  ),
                );
              }
            },
            child: BlocBuilder<PerfilConfigBloc, PerfilConfigState>(
              builder: (context, state) {
                if (state is Cargando) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DatosPreviosCargados) {
                  if (state.usuario != null) {
                    _tycContenido = state.tyc;
                    _nombreController.text = state.usuario!.nombre;
                    _apellidoController.text = state.usuario!.apellido;
                    _ciudadController.text = state.usuario!.localidad;
                  }
                  return SingleChildScrollView(
                    child: _buildForm(state.usuario),
                  );
                } else if (state is ErrorOcurrido) {
                  return const Center(
                    child: Text(
                      'Ocurrió un error',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Usuario? usuario) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: _getImageProvider(usuario),
                            child: _image == null
                                ? const Icon(Icons.add_a_photo, size: 50)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nombre';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _apellidoController,
                          decoration: const InputDecoration(
                            labelText: 'Apellido',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu apellido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _ciudadController,
                          decoration: const InputDecoration(
                            labelText: 'Ciudad',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu ciudad';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        if (terminosRequeridos())
                          CheckboxListTile(
                            title: GestureDetector(
                              onTap: _mostrarTerminosYCondiciones,
                              child: Text(
                                'Acepto los términos y condiciones',
                                style: TextStyle(decoration: TextDecoration.underline),
                              ),
                            ),
                            value: _terminosAceptados,
                            onChanged: (bool? value) {
                              if (_terminosAceptados) { 
                                setState(() {
                                  _terminosAceptados = value ?? false;
                                });
                              }
                            },
                            controlAffinity: ListTileControlAffinity.leading, 
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider<Object>? _getImageProvider(Usuario? usuario) {
    if (_image != null) {
      return FileImage(_image!);
    } else if (usuario == null) {
      return const NetworkImage(
          "https://firebasestorage.googleapis.com/v0/b/veo-veo-9d124.appspot.com/o/perfiles%2Fdefault.jpg?alt=media&token=e55e863a-859b-45d5-8066-8524f247a55f");
    } else if (usuario.urlPerfil.isNotEmpty) {
      return NetworkImage(usuario.urlPerfil);
    } else {
      return null;
    }
  }
}