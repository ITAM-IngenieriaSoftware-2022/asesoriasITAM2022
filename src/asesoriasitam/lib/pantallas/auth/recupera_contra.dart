import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/widgets/actionButton.dart';
import 'package:asesoriasitam/widgets/textInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecoveryPassword extends StatefulWidget {
  const RecoveryPassword({Key? key}) : super(key: key);

  @override
  _RecoveryPasswordState createState() => _RecoveryPasswordState();
}

class _RecoveryPasswordState extends State<RecoveryPassword> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late String _email;
  bool _isSending = false;
  bool _sent = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _sendRecoveryEmail() async {
    FormState formState = _formKey.currentState!;
    formState.save();
    if (formState.validate()) {
      print('Enviando correo para recuperar contraseña a $_email');
      setState(() {
        _isSending = true;
      });
      try {
        await auth.sendPasswordResetEmail(email: _email);
        setState(() {
          _isSending = false;
          _sent = true;
        });
      } catch (e) {
        print(e);
        showSnack(
            context: context, text: "Se produjo un error... checa tu correo");
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: CloseButton(color: Theme.of(context).primaryColor),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: screenSize.height * 0.5,
                        height: screenSize.height * 0.5,
                        child: Image(
                          image: AssetImage(
                              "imagenes/chemsCompletos/cheems lagrima.png"),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Recupera tu contraseña",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      _sent
                          ? Text(
                              "Se ha enviado un correo con instrucciones para reestablecer tu contraseña")
                          : Text(
                              "Enviaremos una liga a tu correo para reestablecer tu contraseña"),
                      _sent
                          ? Container()
                          : CustomTextInput(
                              labelText: "Tu correo",
                              onSaved: (val) => _email = val!),
                      SizedBox(height: 16),
                      _sent
                          ? Container()
                          : CustomActionButton(
                              text: "Enviar correo",
                              onPressed: _sendRecoveryEmail,
                              isSubmitting: _isSending,
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
