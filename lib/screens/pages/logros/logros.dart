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
  void initState(){
    super.initState();
    service = UsuarioService();
  }

@override
Widget build(BuildContext context) {
  final userProvider = Provider.of<UsuarioManager>(context, listen: false);
  Usuario? usuario = userProvider.user;
  return Container(
    color: Colors.grey[200],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: StreamBuilder(
                    stream: service.obtenerLogrosUsuario(usuario!.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Ocurrio un error al obtener los logros.'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final puntoDeInteres = snapshot.data![index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(puntoDeInteres.portada),
                            ),
                            title: Text(puntoDeInteres.nombre),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetallePDIPage(detalle: puntoDeInteres),
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
            ],
          ),
        );
      }
    }