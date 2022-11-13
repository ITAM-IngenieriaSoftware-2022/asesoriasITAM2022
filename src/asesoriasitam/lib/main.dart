import 'package:asesoriasitam/pantallas/auth/registro.dart';
import 'package:asesoriasitam/pantallas/inicio.dart';
import 'package:asesoriasitam/pantallas/auth/login.dart';
import 'package:asesoriasitam/pantallas/perfil/perfil.dart';
import 'package:asesoriasitam/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'db/auth_services.dart';
import 'firebase_options.dart';
import 'global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
            initialData: null,
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges),
      ],
      child: MaterialApp(
        title: 'Asesorias ITAM',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        // Quita scrollbar globalmente
        builder: (context, child) {
          return ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: child!,
          );
        },
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    print("auth wrapper ${firebaseUser}");
    // print("firebaseUser changed here ${firebaseUser.emailVerified}");
    if (firebaseUser == null) {
      return Login();
    } else if (firebaseUser != null &&
        !Global.registering &&
        !firebaseUser.emailVerified) {
      return Registration();
    } else if (firebaseUser != null && !Global.registering) {
      print("user waiting in");
      print(firebaseUser.email);
      return Inicio();
    } else {
      return Text('a');
    }
  }
}
