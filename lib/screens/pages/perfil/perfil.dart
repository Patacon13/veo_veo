import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/providers/user_provider.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UsuarioManager>(context, listen: false);
    Usuario? usuario = userProvider.user;
    _telefonoController.text = usuario?.numeroTelefono ?? '';
    _ciudadController.text = usuario?.localidad ?? '';
  }

  @override
  void dispose() {
    _telefonoController.dispose();
    _ciudadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfile(context),
              const SizedBox(height: 20),
              _buildProfileDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    final userProvider = Provider.of<UsuarioManager>(context, listen: false);
    Usuario? usuario = userProvider.user;
    return GestureDetector(
      onTap: () {
        _mostrarFotoAmpliada(usuario, context);
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(usuario!.urlPerfil),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${usuario.nombre} ${usuario.apellido}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles del Perfil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const Divider(color: Colors.teal),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.teal),
              title: const Text('Teléfono'),
              subtitle: TextField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  hintText: 'Introduce tu teléfono',
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_city, color: Colors.teal),
              title: const Text('Ciudad'),
              subtitle: TextField(
                controller: _ciudadController,
                decoration: const InputDecoration(
                  hintText: 'Introduce tu ciudad',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarFotoAmpliada(Usuario usuario, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(usuario.urlPerfil),
          ),
        );
      },
    );
  }
}
