import 'package:flutter/material.dart';
import 'package:veo_veo/screens/pages/login/login.dart';
import 'package:veo_veo/screens/pages/logros/logros.dart';
import 'package:veo_veo/screens/pages/mapa/mapa.dart';
import 'package:veo_veo/screens/pages/perfil/perfil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:veo_veo/screens/pages/scan/scan.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(VeoVeo());
}


class VeoVeo extends StatelessWidget {
  bool logueado = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veo Veo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        home: logueado ? HomePage() : LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    LogrosPage(),
    ScanPage(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veo Veo'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
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
