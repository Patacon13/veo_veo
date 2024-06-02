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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(left: 0, bottom: 16),
              title: Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Mis Logros",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/veo-veo-9d124.appspot.com/o/misLogros%2Fsanta-fe-logo.jpg?alt=media&token=42786737-7de2-4af7-89b6-523685081252', // Ejemplo de imagen de Unsplash
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
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
