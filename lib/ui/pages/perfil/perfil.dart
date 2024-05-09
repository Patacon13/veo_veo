import 'package:flutter/material.dart';
import 'package:veo_veo/domain/entities/usuario.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String idLog = "1";
  late Future<Usuario> logueado;

  @override
  void initState()  {
    super.initState();
    logueado =  Usuario.fromId(idLog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<Usuario>(
              future: logueado,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  Usuario usuario = snapshot.data!;
                  return GestureDetector(
                    onTap: () {
                      _mostrarFotoAmpliada(usuario);
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
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _mostrarFotoAmpliada(Usuario usuario) {
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
