import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/screens/pages/detalle_pdi/detalle_pdi.dart';
import 'package:veo_veo/services/usuario_services.dart';

class LogrosPage extends StatefulWidget {
  @override
  _LogrosPageState createState() => _LogrosPageState();
}

class _LogrosPageState extends State<LogrosPage> {
  late Future<Usuario> logueado;
  late UsuarioService service;

  @override
  void initState() {
    super.initState();
    service = UsuarioService();
  }

  String _shortenDescription(String description, {int maxLength = 50}) {
    if (description.length <= maxLength) {
      return description;
    } else {
      return '${description.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsuarioManager>(context, listen: false);
    Usuario? usuario = userProvider.user;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            height: 150,
            color: Colors.grey[200],
            width: double.infinity,
            child: Image.asset(
              'assets/portada_logros.jpg', 
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              "Puntos descubiertos",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: StreamBuilder(
                    stream: service.obtenerLogrosUsuario(usuario!.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Ocurrió un error al obtener los logros.'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No tienes ningún logro todavía :(',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final puntoDeInteres = snapshot.data![index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(puntoDeInteres.portada),
                            ),
                            title: Text(
                              puntoDeInteres.nombre,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              _shortenDescription(puntoDeInteres.descripcion),
                              style: TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black26),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetallePDIPage(detalle: puntoDeInteres),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
