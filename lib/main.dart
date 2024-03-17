import 'package:flutter/material.dart';
import 'package:veo_veo/widget/country_picker_widget.dart';
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

  void _handleInputChanged(String value, String field) {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veo Veo'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                CountryPickerWidget(), // Country picker widget
                SizedBox(width: 10), // Spacer between country picker and text field
                Expanded(
                  child: TextField(
                    onChanged: (value) => _handleInputChanged(value, 'phoneNumber'),
                    decoration: const InputDecoration(
                      labelText: 'Número de teléfono',
                      hintText: 'Introduzca su número',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Registrarse/Ingresar'),
              ),
            ),
          ],

        ),

      ),

    );

  }

}
