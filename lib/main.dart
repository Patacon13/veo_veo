import 'package:flutter/material.dart';
import 'package:veo_veo/ui/pages/login/login.dart';
import 'package:veo_veo/ui/pages/scan_qr/scan_qr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veo Veo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    QRScannerPage(),
    LoginPage(),
    // Agrega aquí tus otras páginas o pestañas
    // Ejemplo:
    // OtherPage1(),
    // OtherPage2(),
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
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scanear QR',
          ),
           BottomNavigationBarItem(
             icon: Icon(Icons.home),
             label: 'Home',
           ),
        ],
      ),
    );
  }
}
