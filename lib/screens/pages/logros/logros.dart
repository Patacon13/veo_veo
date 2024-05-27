import 'package:flutter/material.dart';
import 'package:veo_veo/models/usuario.dart';
import 'package:veo_veo/screens/pages/detalle_pto_de_interes/detalle.dart';

class LogrosPage extends StatefulWidget {
  @override
  _LogrosPageState createState() => _LogrosPageState();
}


class _LogrosPageState extends State<LogrosPage> {
  late Future<Usuario> logueado;
  
  @override
  void initState(){
    super.initState();
    logueado =  Usuario.fromId("1");

  }

@override
Widget build(BuildContext context) {
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
            child: FutureBuilder(
              future: logueado,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  final usuario = snapshot.data as Usuario; 
                  return StreamBuilder(
                    stream: usuario.obtenerLogrosUsuario(),
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
                                  builder: (context) => DetallePage(detalle: puntoDeInteres),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        )
      ],
    ),
  );
}
}