import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:veo_veo/screens/pages/login/bloc/login_bloc.dart';
import 'package:veo_veo/screens/pages/mapa/bloc/mapa_bloc.dart';
import 'package:veo_veo/screens/pages/perfil/perfil_config.dart';
import 'providers/user_provider.dart';
import 'screens/pages/home/home.dart';
import 'screens/pages/login/login.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const VeoVeo());
}

class VeoVeo extends StatelessWidget {
  const VeoVeo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsuarioManager()),
        BlocProvider(create: (context) => LoginBloc()),
      ],
      child: const MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    final userProvider = Provider.of<UsuarioManager>(context);
    bloc.userProvider = userProvider;
    return FutureBuilder<int>(
      future: userProvider.crearSesion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.data == 1) {
          return HomePage();
        } else if (snapshot.data == 2) {
          return PerfilConfigPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}