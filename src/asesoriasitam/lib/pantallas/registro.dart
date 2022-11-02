import 'dart:async';

import 'package:asesoriasitam/db/auth_services.dart';
import 'package:asesoriasitam/db/carrera_bloc.dart';
import 'package:asesoriasitam/db/clases/carrera.dart';

import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/pantallas/inicio.dart';
import 'package:asesoriasitam/widgets/actionButton.dart';
import 'package:asesoriasitam/widgets/smallActionButton.dart';
import 'package:asesoriasitam/widgets/textInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/db/usuario_bloc.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  //Data
  FirebaseAuth auth = FirebaseAuth.instance;
  late Usuario usuario = Usuario();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Timer _timer;

  //Send verification form
  final _sendVerificationformKey = GlobalKey<FormState>();
  late String _password, _passwordConfirm;
  bool _isSubmittingFirst = false;

  //Complete user form
  final _completeRegistrationformKey = GlobalKey<FormState>();
  final DateTime timestamp = DateTime.now();
  TextEditingController _carrerasController = TextEditingController();
  bool _isCompleting = false;

  //Chips
  List<Carrera> carreras = [];
  List<Carrera> carrerasSeleccionadas = [];
  List<String> carrerasUsuario = [];
  Map<String, bool> chipSelected = Map<String, bool>();
  bool gotCarreras = false;

  //UI controllers
  bool _waitingVerification = false;
  bool _userEmailVerified = false;
  bool _complete = false;
  bool _resendButton = false;
  bool _relogging = false;
  bool _legal = false;

  @override
  void initState() {
    super.initState();
    _getCarreras();
    if (auth.currentUser != null) {
      AuthenticationService(auth).sendVerificationEmail(email: "");
      setState(() {
        _isSubmittingFirst = false;
        _waitingVerification = true;
      });
    }
    Future(() async {
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (auth.currentUser != null && _waitingVerification) {
          await auth.currentUser!.reload();
          print("reloaded user: ${auth.currentUser!.email}");
          if (auth.currentUser!.emailVerified) {
            //_getCarreras();
            setState(() {
              _userEmailVerified = true;
              _waitingVerification = false;
            });
            timer.cancel();
          } else {
            _resendButton = false;
          }
        }
      });
    });
  }

  Future<void> _manuallyCheckEmailVerified() async {
    print("manually");
    var curr = auth.currentUser;
    if (curr != null) {
      await curr.reload();
      //print("reloaded user: ${auth.currentUser!.email}");
      if (curr.emailVerified) {
        _getCarreras();
        setState(() {
          _userEmailVerified = true;
          _waitingVerification = false;
        });
      } else {
        showSnack(context: context, text: "No encontramos tu verificación");
      }
    } else {
      await AuthenticationService(auth)
          .signIn(email: usuario.correo ?? "", password: _password);
      _manuallyCheckEmailVerified();
    }
  }

  Future<void> _createUserInFirestore() async {
    usuario.uid = FirebaseAuth.instance.currentUser!.uid;
    usuario.correo = FirebaseAuth.instance.currentUser!.email;
    usuario.nombre = "Tu Nombre";
    usuario.apellido = "Tu Apellido";
    usuario.carreras = [];
    usuario.instagram = "";
    usuario.twitter = "";
    usuario.facebook = "";
    usuario.bio = "";
    usuario.grupos = {};
    usuario.clases = {};
    usuario.chems = 0;
    usuario.semestre = 1;
    usuario.fechaRegistro = timestamp;
    usuario.carreras = carrerasUsuario;
    usuario.foto = "regular.png";
    UsuarioBloc().registerUser(usuario: usuario);
  }

  Future<void> _updateUserInFirestore() async {
    usuario.uid = FirebaseAuth.instance.currentUser!.uid;
    usuario.fechaRegistro = timestamp;
    usuario.carreras = carrerasUsuario;
    usuario.foto = "regular.png";
    UsuarioBloc().addUserToDB(usuario: usuario);
  }

  Future<void> _submitPrimerPaso() async {
    FormState formState = _sendVerificationformKey.currentState!;
    formState.save();
    if (formState.validate()) {
      setState(() {
        _isSubmittingFirst = true;
      });
      try {
        Global.registering = true;
        //signup and send email
        String? logMessage = await context
            .read<AuthenticationService>()
            .signUp(email: usuario.correo!, password: _password);
        if (logMessage != null &&
            logMessage != "Ya existe una cuenta con este correo.") {
          showSnack(context: context, text: logMessage);
          setState(() {
            _isSubmittingFirst = false;
          });
        } else {
          await _createUserInFirestore();
          //await AuthenticationService(auth)
          //.sendVerificationEmail(email: usuario.correo!);
          setState(() {
            _isSubmittingFirst = false;
            _waitingVerification = true;
          });
        }
      } catch (e) {
        print(e);
        setState(() {
          _isSubmittingFirst = false;
        });
        showSnack(context: context, text: "Occurio un error");
      }
    }
  }

  Future<void> _submitCompletar() async {
    FormState formState = _completeRegistrationformKey.currentState!;
    formState.save();
    if (formState.validate()) {
      setState(() {
        _isCompleting = true;
      });
      try {
        await _updateUserInFirestore();
        setState(() {
          _complete = true;
        });
      } catch (e) {
        showSnack(
            context: context,
            text: "Unu! se produjo un error. Intenta el registro de nuevo");
      }
    }
  }

  Future<void> _getCarreras() async {
    carreras = [];
    try {
      List<Carrera> nuevos = await CarreraBloc().getCarreras();
      setState(() {
        carreras = nuevos;
        gotCarreras = true;
        print("got ${carreras.length} carreras");
        for (Carrera c in carreras) {
          chipSelected[c.nombre] = false;
        }
      });
    } catch (e) {
      print("error getting carreras:");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: CloseButton(color: Theme.of(context).primaryColor),
        ),
        body: _correspondingPage());
  }

  Widget _correspondingPage() {
    if (_complete) {
      return _registroCompleto();
    } else if (_waitingVerification) {
      return _esperandoVerificacion();
    } else if (!_userEmailVerified) {
      return _primerPasoRegistro();
    } else {
      return _completarRegistro();
    }
  }

  Widget _registroCompleto() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('imagenes/collage.png'),
          SizedBox(height: 24),
          Text(
            "¡Bienvenidx a Comunidad 2.0!",
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 8),
          SmallActionButton(
            text: "Ir a Inicio",
            isSubmitting: _relogging,
            backgroundColor: Palette.mainGreen,
            foregroundColor: Colors.white,
            onPressed: () async {
              setState(() {
                _relogging = true;
              });
              if (_password != null) {
                await AuthenticationService(auth).signOut();
                await AuthenticationService(auth)
                    .signIn(email: usuario.correo ?? "", password: _password);
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Inicio(),
                ),
                (route) => false,
              );
            },
          )
        ],
      ),
    ));
  }

  Widget _esperandoVerificacion() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Se ha enviado un link a tu correo",
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 16),
          Text(
              "Abre el link para verificar tu correo y después vuelve para completar tu registro."),
          SizedBox(height: 24),
          Center(
              child: SmallActionButton(
            onPressed: () {
              setState(() {
                _resendButton = true;
              });
              auth.currentUser!.sendEmailVerification();
            },
            backgroundColor: Palette.mainGreen,
            foregroundColor: Colors.white,
            isSubmitting: _resendButton,
            text: "Reenviar",
          )),
          SizedBox(height: 24),
          RichText(
            text: TextSpan(
                text:
                    "Una vez verificado el correo esta página debería detectarlo automáticamente en unos segundos o puedes: ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: "Refrescar.",
                      style: TextStyle(color: Palette.mainGreen),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _manuallyCheckEmailVerified();
                        })
                ]),
          ),
        ],
      ),
    ));
  }

  Widget _primerPasoRegistro() {
    final screenSize = MediaQuery.of(context).size;
    final _tappableStyle = TextStyle(color: Palette.mainGreen);
    final _normalStyle = TextStyle(color: Colors.black);
    return Form(
      key: _sendVerificationformKey,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                        "Primero vamos a crear tu cuenta y verificar tu correo",
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(height: 16),
                    CustomTextInput(
                      labelText: "Correo",
                      onSaved: (val) => usuario.correo = val!,
                      keyboardType: TextInputType.emailAddress,
                      // validator: (val) => !val.contains("@itam.mx")
                      // ? "Solo de permite registro con tu correo institucional"
                      // : null,
                    ),
                    SizedBox(height: 16),
                    CustomTextInput(
                      labelText: "Contraseña",
                      isPassword: true,
                      onSaved: (val) => _password = val!,
                      validator: (val) => val!.length < 8
                          ? "Contraseña debe ser de por lo menos 8 caracteres"
                          : null,
                    ),
                    SizedBox(height: 16),
                    CustomTextInput(
                      labelText: "Confirma tu contraseña",
                      isPassword: true,
                      onSaved: (val) => _passwordConfirm = val!,
                      validator: (val) => _password != _passwordConfirm
                          ? "Las contraseñas deben coincidir"
                          : null,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              CheckboxListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      maxLines: null,
                      softWrap: true,
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  'Declaro que soy mayor de edad, acepto los ',
                              style: _normalStyle),
                          TextSpan(
                              text: 'Términos y Condiciones',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchURL(Global.terminosURL),
                              style: _tappableStyle),
                          TextSpan(
                              text:
                                  'y autorizo el uso de mis datos de acuerdo al ',
                              style: _normalStyle),
                          TextSpan(
                              text: 'Aviso de Privacidad.',
                              style: _tappableStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => launchURL(Global.privacidadURL)),
                        ],
                      ),
                    ),
                  ),
                  value: _legal,
                  onChanged: (v) => setState(() => _legal = !_legal)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    _legal
                        ? CustomActionButton(
                            text: "Verificar Correo",
                            onPressed: _submitPrimerPaso,
                            isSubmitting: _isSubmittingFirst)
                        : Container(height: 50),
                    SizedBox(height: 32),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _completarRegistro() {
    return Form(
      key: _completeRegistrationformKey,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      "Tu correo ha sido verificado! Completa tu perfil",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 48),
                    CustomTextInput(
                      labelText: "Nombre",
                      onSaved: (val) => usuario.nombre = val!,
                      maxLength: 20,
                      validator: (val) =>
                          val!.length == 0 ? "Ingresa tu nombre" : null,
                    ),
                    SizedBox(height: 8),
                    CustomTextInput(
                      labelText: "Apellido",
                      onSaved: (val) => usuario.apellido = val!,
                      maxLength: 25,
                      validator: (val) =>
                          val!.length == 0 ? "Ingresa tu nombre" : null,
                    ),
                    SizedBox(height: 8),
                    CustomTextInput(
                      labelText: "Semestre",
                      keyboardType: TextInputType.number,
                      onSaved: (val) => usuario.semestre = int.parse(val!),
                      validator: (val) => val != null &&
                              int.parse(val) >= 1 &&
                              int.parse(val) <= 15
                          ? null
                          : "Ingresa un semestre entre 1 y 15",
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Text("Selecciona tu(s) carrera(s)"),
                      ],
                    ),
                    //Text(carrerasUsuario.join(",")),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              _showCarreraInputChips(),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomActionButton(
                    text: "Registrate",
                    onPressed: _submitCompletar,
                    isSubmitting: _isCompleting),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showCarreraInputChips() {
    return gotCarreras
        ? carreraChipWrap()
        : SizedBox(
            height: 100,
          );
  }

  Widget carreraChipWrap() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 32),
              Wrap(
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.start,
                spacing: 8,
                children: carreras
                    .sublist(0, (carreras.length / 3).floor())
                    .map((e) =>
                        _buildChip(e.nombre, Color(e.color).withOpacity(1)))
                    .toList(),
              ),
              SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 48),
              Wrap(
                spacing: 8,
                children: carreras
                    .sublist((carreras.length / 3).ceil(),
                        (2 * carreras.length / 3).floor())
                    .map((e) =>
                        _buildChip(e.nombre, Color(e.color).withOpacity(1)))
                    .toList(),
              ),
              SizedBox(width: 16),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 32),
              Wrap(
                spacing: 8,
                children: carreras
                    .sublist((2 * carreras.length / 3).ceil())
                    .map((e) =>
                        _buildChip(e.nombre, Color(e.color).withOpacity(1)))
                    .toList(),
              ),
              SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String text, Color color) {
    return InputChip(
      key: Key(text),
      labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      label: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color.withOpacity(0.8),
      selectedColor: color,
      checkmarkColor: Colors.white,
      selected: carrerasUsuario.contains(text),
      onPressed: () {
        print(chipSelected);
        print(carrerasUsuario);
        if (carrerasUsuario.length < 2 && !carrerasUsuario.contains(text)) {
          setState(() {
            carrerasUsuario.add(text);
          });
        } else {
          setState(() {
            carrerasUsuario.remove(text);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
