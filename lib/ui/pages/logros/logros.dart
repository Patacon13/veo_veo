import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:veo_veo/ui/pages/detalle_pto_de_interes/detalle.dart';

class LogrosPage extends StatefulWidget {
  @override
  _LogrosPageState createState() => _LogrosPageState();


}

class _LogrosPageState extends State<LogrosPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4, // Elevación de la tarjeta para sombra
            margin: EdgeInsets.all(16),
            color: Colors.white, // Color de la tarjeta blanco
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/user.png'), // Aquí deberías proporcionar la ruta de la imagen de perfil
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre Apellido',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Cantidad de lugares visitados: 1',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/molino.jpg'),
                    ),
                    title: Text('Molino'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetallePage(detalle: 'Molino'),
                        ),
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