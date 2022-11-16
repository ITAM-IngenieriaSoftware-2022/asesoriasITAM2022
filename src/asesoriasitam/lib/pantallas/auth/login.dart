import 'package:asesoriasitam/db/auth_services.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/pantallas/auth/recupera_contra.dart';
import 'package:asesoriasitam/pantallas/auth/registro.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/widgets/actionButton.dart';
import 'package:asesoriasitam/widgets/textInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String _email, _password;
  bool _isSubmitting = false;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _attemptToLogin() async {
    print("here");
    final _form = _formKey.currentState;
    if (_form!.validate()) {
      _form.save();
      setState(() {
        _isSubmitting = true;
      });
      final logMessage = await context
          .read<AuthenticationService>()
          .signIn(email: _email, password: _password);

      if (logMessage == "Signed In") {
        return;
      } else {
        showSnack(context: context, text: logMessage);
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print("initing login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Asesorias ITAM',
                        style:
                            TextStyle(color: Palette.mainGreen, fontSize: 48),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Encuentra y anuncia asesorias de calidad',
                        style:
                            TextStyle(color: Palette.mainGreen, fontSize: 16),
                      ),
                      SizedBox(height: 32),
                      CustomTextInput(
                        labelText: "Correo",
                        onSaved: (val) => _email = val!,
                        validator: (val) =>
                            val!.contains("@") ? null : "Checa tu correo",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),
                      CustomTextInput(
                        isPassword: true,
                        onSaved: (val) => _password = val!,
                        validator: (val) =>
                            val!.length < 6 ? "Checa tu contraseña" : null,
                        labelText: "Contraseña",
                      ),
                      SizedBox(height: 24),
                      CustomActionButton(
                        text: "Iniciar Sesión",
                        onPressed: _attemptToLogin,
                        isSubmitting: _isSubmitting,
                      ),
                      SizedBox(height: 16),
                      InkWell(
                          onTap: () => goto(context, RecoveryPassword()),
                          child: Text("Recuperar Contraseña",
                              style: TextStyle(
                                  color: Palette.mainGreen, fontSize: 14))),
                      SizedBox(height: 8),
                      InkWell(
                          onTap: () => goto(context, Registration()),
                          child: Text(
                            "Regístrate",
                            style: TextStyle(
                                color: Palette.mainGreen, fontSize: 14),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _image() {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.height * 0.5,
      height: screenSize.height * 0.5,
      child: Image(
        image: AssetImage("imagenes/regularCompleto.png"),
      ),
    );
  }
}
