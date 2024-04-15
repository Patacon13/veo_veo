import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();


}

class _PerfilPageState extends State<PerfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                _mostrarFotoAmpliada();
              },
              child: Card(
                elevation: 4,
                margin: EdgeInsets.all(16),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
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
                              'Nombre Apellido',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Correo electrónico: usuario@gmail.com',
                            ),
                            Text(
                              'Teléfono: +54 1234567890',
                            ),
                            Text(
                              'Ciudad: Santa Fe',
                            ),
                            Text(
                              'Cantidad de lugares descubiertos: 1',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

          ],
        ),
      ),
    );
  }

  void _mostrarFotoAmpliada() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage('assets/user.png'),
          ),
        );
      },
    );
  }
}