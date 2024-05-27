import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/pages/home/home.dart';
import 'screens/pages/login/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VeoVeo());
}

class VeoVeo extends StatelessWidget {
  const VeoVeo({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => UsuarioManager(),
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UsuarioManager>(context);
    return FutureBuilder<bool>(
      future: userProvider.crearSesion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data == true) {
          print('ID: ${userProvider.user!.id}');
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

