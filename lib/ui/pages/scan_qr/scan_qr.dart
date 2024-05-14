import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:veo_veo/domain/entities/usuario.dart';
import 'package:veo_veo/main.dart';

Future<dynamic> compareImages(File imageFile) async {
  final url = 'http://192.168.100.4:5000/compare_images';
  String base64Image = base64Encode(imageFile.readAsBytesSync());

  final response = await http.post(Uri.parse(url), body: {
    'image1': 'data:image/jpeg;base64,$base64Image',
  });

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Fallo de conexión con el servidor.');
  }
}

class ImageCaptureScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      dynamic response = await compareImages(imageFile);
      dynamic score = response['similarity_score'];
      dynamic punto = response['best_match_id'];
      if(score > 0.05){
        print('Score: $score con el punto $punto');
        Usuario usuario = await Usuario.fromId("1");
        await usuario.registrarLogro(punto);
          Navigator.pushReplacement(
          context,
           MaterialPageRoute(builder: (context) => HomePage()),
        );     
   } else {
        print('No se encontró coincidencia.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capturar imagen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _captureImage(context),
          child: Text('Capturar imagen'),
        ),
      ),
    );
  }
}
