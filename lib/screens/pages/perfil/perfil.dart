import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/providers/user_provider.dart'; // Importa tu UserProvider

class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Consumer<UsuarioManager>(
          builder: (context, userProvider, _) {
            final usuario = userProvider.user;
            if (usuario == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return _buildProfile(usuario, context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfile(Usuario usuario, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _mostrarFotoAmpliada(usuario, context);
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(16),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/user.png'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${usuario.nombre} ${usuario.apellido}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Correo electrónico: ${usuario.email}',
                    ),
                    Text(
                      'Teléfono: ${usuario.numeroTelefono}',
                    ),
                    Text(
                      'Ciudad: ${usuario.localidad}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarFotoAmpliada(Usuario usuario, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage('assets/user.png'),
          ),
        );
      },
    );
  }
}
