import 'package:asesoriasitam/db/auth_services.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/pantallas/auth/login.dart';
import 'package:asesoriasitam/utils/usefulWidgets.dart';
import 'package:asesoriasitam/widgets/textInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AjustesPerfil extends StatefulWidget {
  final Usuario usuario;
  const AjustesPerfil({Key? key, required this.usuario}) : super(key: key);

  @override
  _AjustesPerfilState createState() => _AjustesPerfilState();
}

class _AjustesPerfilState extends State<AjustesPerfil> {
  int descargasDisponibles = -1;
  TextEditingController _passwordController = TextEditingController();

  ///Prompts for password, reauthenticates and deletes user.
  Future<void> _borrarUsuario() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Ingresa tu contraseña"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Necesitamos tu contraseña para confirmar esta operación"),
                  CustomTextInput(
                    controller: _passwordController,
                    labelText: "Contraseña",
                    isPassword: true,
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      print("here");
                      try {
                        await AuthenticationService(FirebaseAuth.instance)
                            .reauth(password: _passwordController.text);
                        await AuthenticationService(FirebaseAuth.instance)
                            .deleteCurrentUser();
                        AuthenticationService(FirebaseAuth.instance).signOut();
                        goto(context, Login());
                      } catch (e) {
                        print("Error deleting user: $e");
                        showSnack(
                            context: context,
                            text:
                                "Unu se produjo un error intentando borrar tu cuenta");
                      }
                      //_borrarUsuario();
                    },
                    child: Text("Confirmar"))
              ],
            ));
    //await AuthenticationService(FirebaseAuth.instance).deleteCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajustes")),
      body: _mainBody(),
    );
  }

  Widget _mainBody() {
    return CenteredConstrainedBox(
      child: Column(
        children: [
          _desactivarTile(),
          ListTile(
            title: Text("Términos y Condiciones"),
            onTap: () => launchURL(Global.terminosURL),
          ),
          ListTile(
            title: Text("Aviso de Privacidad"),
            onTap: () => launchURL(Global.privacidadURL),
          ),
          AboutListTile(
            applicationVersion: "Beta",
          )
        ],
      ),
    );
  }

  Widget _desactivarTile() {
    return ListTile(
        title: Text(
          "Borrar Cuenta",
        ),
        onTap: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Column(
                      children: [
                        Icon(
                          CupertinoIcons.exclamationmark_triangle_fill,
                          color: Colors.red,
                          size: 32,
                        ),
                        SizedBox(height: 16),
                        Text("Borrar Cuenta",
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    content:
                        Text("¿Estás seguro que quieres borrar tu cuenta?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cancelar")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _borrarUsuario();
                          },
                          child: Text("Borrar Cuenta",
                              style: TextStyle(color: Colors.red))),
                    ])));
  }
}
