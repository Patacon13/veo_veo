import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/providers/user_provider.dart';
import 'package:veo_veo/screens/pages/login/login.dart';
import 'package:veo_veo/screens/pages/logros/logros.dart';
import 'package:veo_veo/screens/pages/mapa/mapa.dart';
import 'package:veo_veo/screens/pages/perfil/perfil.dart';
import 'package:veo_veo/screens/pages/perfil/perfil_config.dart';

class HomePage extends StatefulWidget {
  final int interfazInicial;
    HomePage({Key? key, this.interfazInicial = 0}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _paginaActual;
  final List<Widget> _paginas = [
    LogrosPage(),
    MapaPage(),
    PerfilPage(),
  ];

@override
  void initState() {
    super.initState();
    _paginaActual = widget.interfazInicial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Row(
    children: [
      Text(
        'VEO VEO',
        style: TextStyle(
          fontFamily: 'Roboto', 
          fontWeight: FontWeight.bold,
          fontSize: 20, 
          letterSpacing: 1.5, 
          color: Colors.blue, 
        ),
    ),
      Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Icon(Icons.remove_red_eye, color: Colors.blue,), 
        ),
    ],
  ),
  automaticallyImplyLeading: false,  
  actions: _paginaActual == 2 ? [ // Si la interfaz es el perfil, agrego botones
    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PerfilConfigPage(volverAtras: true),
          ),
        );
      },
    ),
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        final userProvider = Provider.of<UsuarioManager>(context, listen: false);
        userProvider.signout(); // destruyo la sesion desde el provider
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
    ),
  ]
  : null,
),
      body: _paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          setState(() {
            _paginaActual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Logros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
