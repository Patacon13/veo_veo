import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/screens/pages/home/home.dart';
import 'package:veo_veo/screens/pages/perfil/bloc/perfil_config_bloc.dart';

class PerfilConfigPage extends StatefulWidget {
  @override
  _PerfilConfigPageState createState() => _PerfilConfigPageState();
}

class _PerfilConfigPageState extends State<PerfilConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _ciudadController = TextEditingController();
  PerfilConfigBloc bloc = PerfilConfigBloc();
  File? _image;

  @override
  void initState() {
    super.initState();
    bloc.add(DatosPreviosRequeridos());
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final apellido = _apellidoController.text;
      final ciudad = _ciudadController.text;
      Usuario rec = Usuario('', nombre, apellido, '', '', ciudad, '', true, "");
      bloc.add(DatosEnviados(usuario: rec, foto: _image));
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc.userProvider = Provider.of<UsuarioManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Perfil'),
        automaticallyImplyLeading: false,  
      ),
        body: BlocProvider(
        create: (context) => bloc,
        child: BlocListener<PerfilConfigBloc, PerfilConfigState>(
          listener: (context, state) {
            if (state is DatosCargadosCorrectamente) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(interfazInicial: 2)),
              );
            }
          },
      child: BlocBuilder<PerfilConfigBloc, PerfilConfigState>(
        builder: (context, state) {
          if (state is Cargando) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DatosPreviosCargados) {
            if(state.usuario != null){
              _nombreController.text = state.usuario!.nombre;
              _apellidoController.text = state.usuario!.apellido;
              _ciudadController.text = state.usuario!.localidad;
            }
            return _buildForm(state.usuario);
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
    );    
  }

  Widget _buildForm(Usuario? usuario) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _getImageProvider(usuario),
                  child: _image == null
                      ? const Icon(Icons.add_a_photo, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
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
                decoration: const InputDecoration(labelText: 'Apellido'),
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
                decoration: const InputDecoration(labelText: 'Ciudad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu ciudad';
                  }
                  return null;
                },
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
    );
  }

  ImageProvider<Object>? _getImageProvider(Usuario? usuario) {
    if (_image != null) {
      return FileImage(_image!);
    } else if(usuario == null){
      return const NetworkImage("https://firebasestorage.googleapis.com/v0/b/veo-veo-9d124.appspot.com/o/perfiles%2Fdefault.jpg?alt=media&token=e55e863a-859b-45d5-8066-8524f247a55f");
    } else if (usuario.urlPerfil.isNotEmpty) {
      return NetworkImage(usuario.urlPerfil);
    } else {
      return null;
    }
  }
}
