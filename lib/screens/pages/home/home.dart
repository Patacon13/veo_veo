import 'package:flutter/material.dart';
import 'package:veo_veo/screens/pages/logros/logros.dart';
import 'package:veo_veo/screens/pages/perfil/perfil.dart';
import 'package:veo_veo/screens/pages/scan/scan.dart';

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
    ScanPage(),
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
        title: Text('Veo Veo'),
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
