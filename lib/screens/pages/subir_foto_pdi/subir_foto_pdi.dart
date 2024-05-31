import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/models/punto_de_interes.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/screens/pages/home/home.dart';
import 'dart:io';

import 'package:veo_veo/screens/pages/subir_foto_pdi/bloc/subir_foto_pdi_bloc.dart';

class SubirFotoPDIPage extends StatefulWidget {
  final PuntoDeInteres? punto;
  SubirFotoPDIPage({Key? key, this.punto}) : super(key: key);

  @override
  _SubirFotoPDIPageState createState() => _SubirFotoPDIPageState();
}

class _SubirFotoPDIPageState extends State<SubirFotoPDIPage> {
  File? _imagen;
  SubirFotoPDIBloc bloc = SubirFotoPDIBloc();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagen = File(pickedFile.path);
      });
    }
  }

  void _subirImagen() {
    if (_imagen != null) {
      bloc.add(FotoEnviada(imagen: _imagen, punto: widget.punto!));
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc.userProvider = Provider.of<UsuarioManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargar foto de ${widget.punto?.nombre ?? ''}'),
      ),
      body: Stack(
        children: [
          Center( 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _imagen == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera,
                              size: 100,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'No se ha seleccionado una imagen.',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _imagen!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tomar Foto'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _imagen == null ? null : _subirImagen,
                    icon: const Icon(Icons.upload),
                    label: const Text('Subir Foto'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocProvider(
            create: (context) => bloc,
            child: BlocListener<SubirFotoPDIBloc, SubirFotoPDIState>(
              listener: (context, state) {
                if (state is ImagenCargadaCorrectamente) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(interfazInicial: 0)),
                  );
                }
              },
              child: BlocBuilder<SubirFotoPDIBloc, SubirFotoPDIState>(
                builder: (context, state) {
                  if (state is Cargando) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ErrorOcurrido) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, size: 48.0, color: Colors.red),
                        SizedBox(height: 16.0),
                        Text(
                          'Ocurrió un error al subir la imagen.',
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
