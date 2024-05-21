import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/providers/user_provider.dart';

class PerfilConfigPage extends StatefulWidget {
  @override
  _PerfilConfigPageState createState() => _PerfilConfigPageState();
}

class _PerfilConfigPageState extends State<PerfilConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _ciudadController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submit() {
    final userProvider = Provider.of<UsuarioManager>(context);
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text;
      final apellido = _apellidoController.text;
      final ciudad = _ciudadController.text;
      Usuario rec = Usuario('', nombre, apellido, '', '', ciudad, ''); //deberia ser un bloc, no hacerlo directamente en
      userProvider.completarRegistro(rec);  
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar Perfil'),
      ),
      body: Padding(
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
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.add_a_photo, size: 50)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _apellidoController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _ciudadController,
                  decoration: InputDecoration(labelText: 'Ciudad'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu ciudad';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
