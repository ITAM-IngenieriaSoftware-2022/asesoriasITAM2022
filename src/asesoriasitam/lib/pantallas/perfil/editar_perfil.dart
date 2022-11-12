import 'package:asesoriasitam/db/carrera_bloc.dart';
import 'package:asesoriasitam/db/clases/carrera.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/widgets/textInput.dart';
import 'package:asesoriasitam/widgets/userAvatar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/db/usuario_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfile extends StatefulWidget {
  final Usuario usuario;
  EditProfile({Key? key, required this.usuario});
  @override
  _EditProfileState createState() => _EditProfileState(usuario);
}

class _EditProfileState extends State<EditProfile> {
  Usuario usuario;
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();
  List<Carrera> carreras = [];
  List<String> carrerasUsuario = [];
  late Map<String, bool> chipSelected;
  bool gotCarreras = false;
  List<String> _profilePicsFiles = [
    'regular.png',
    'lagrima.png',
    'primersemestre.png',
    'desvelado.png',
    'audifonos.png',
    'lentes.png',
    'emo.png',
    'feminista.png',
    'malandro.png',
    'otaku.png',
    'artista.png',
    'inge.png',
    'cientifico.png',
    'fifas.png',
  ];
  Map<String, int> _chemsRequiredForPic = {
    'regular.png': 0,
    'lagrima.png': 0,
    'primersemestre.png': 0,
    'desvelado.png': 500,
    'audifonos.png': 500,
    'lentes.png': 500,
    'emo.png': 1000,
    'feminista.png': 1000,
    'malandro.png': 1000,
    'otaku.png': 1000,
    'artista.png': 1000,
    'inge.png': 1000,
    'cientifico.png': 1000,
    'fifas.png': 1000
  };
  late String _selectedProfilePic;

  _EditProfileState(this.usuario);
  @override
  void initState() {
    super.initState();
    _selectedProfilePic = usuario.foto ?? "regular.png";
    chipSelected = Map<String, bool>();
    getCarreras();
  }

  ///Validates, saves and attempts to update user
  Future<void> _attemptToUpdateUser() async {
    final _form = _formKey.currentState;
    if (_form!.validate()) {
      _form.save();
      setState(() {
        _isSubmitting = true;
      });
      try {
        await UsuarioBloc().updateUsuario(usuario: usuario);
        setState(() {
          _isSubmitting = false;
        });
        Navigator.pop(context, true);
      } catch (e) {
        print(e);
        setState(() {
          _isSubmitting = false;
        });
        showSnack(
            text: "UnU No se pudo actualizar tu perfil", context: context);
      }
    }
  }

  getCarreras() async {
    carreras = [];
    try {
      List<Carrera> nuevos = await CarreraBloc().getCarreras();
      setState(() {
        carreras = nuevos;
        gotCarreras = true;
        print("got ${carreras.length} carreras");
        for (Carrera c in carreras) {
          if (usuario.carreras!.contains(c.nombre)) {
            carrerasUsuario.add(c.nombre);
            chipSelected[c.nombre] = true;
          } else {
            chipSelected[c.nombre] = false;
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: _isSubmitting,
        title: _isSubmitting
            ? Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ))
            : null,
        leading: CloseButton(),
        actions: [
          _isSubmitting
              ? Container()
              : IconButton(
                  icon: Icon(Icons.check), onPressed: _attemptToUpdateUser)
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  //Imagen
                  Container(
                    color: Palette.mainGreen,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        _showImageInput(context),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  //Nombre-Semestre
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Wrap(
                          spacing: 20,
                          children: [
                            //Nombre
                            CustomTextInput(
                              labelText: "Nombre",
                              initialText: usuario.nombre,
                              onSaved: (val) => usuario.nombre = val,
                              validator: (val) =>
                                  val!.length == 0 ? "Ingresa tu nombre" : null,
                            ),
                            //Apellido
                            CustomTextInput(
                              labelText: "Apellido",
                              initialText: usuario.apellido,
                              onSaved: (val) => usuario.apellido = val,
                              validator: (val) => val!.length == 0
                                  ? "Ingresa tu apellido"
                                  : null,
                            ),
                            //Bio
                            CustomTextInput(
                              labelText: "Bio",
                              initialText: usuario.bio,
                              onSaved: (val) => usuario.bio = val,
                              maxLength: 69,
                              maxLines: null,
                            ),
                            //Semestre
                            CustomTextInput(
                              labelText: "Semestre",
                              initialText: usuario.semestre.toString() != "null"
                                  ? usuario.semestre.toString()
                                  : "0",
                              keyboardType: TextInputType.number,
                              validator: (val) => val != null &&
                                      int.parse(val) >= 1 &&
                                      int.parse(val) <= 15
                                  ? null
                                  : "Ingresa un semestre entre 1 y 15",
                              onSaved: (val) => usuario.semestre =
                                  val != null ? int.parse(val) : null,
                            ),
                            //Carrera(s)
                            CustomTextInput(
                              key: Key(carrerasUsuario.join(", ")),
                              initialText: carrerasUsuario.join(", "),
                              onSaved: (val) =>
                                  usuario.carreras = carrerasUsuario,
                              validator: (val) => carrerasUsuario.length == 0
                                  ? "Ingresa tu carrera"
                                  : null,
                              labelText: "Carrera(s)",
                            ),
                            SizedBox(height: 24)
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Carrera(s) input chips
                  gotCarreras
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: carreraChipWrap())
                      : Container(),
                  //Redes
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 20,
                        children: [
                          SizedBox(height: 24),
                          CustomTextInput(
                            labelText: "Celular",
                            initialText: usuario.tel,
                            onSaved: (val) => usuario.tel = val,
                            helperText: "Opcional",
                            suffixIcon: FontAwesomeIcons.phone,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Dialog that opens with profile picture chooser
  _pickProfilePicture(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancelar")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, _selectedProfilePic);
                },
                child: Text("Guardar")),
          ],
          content: Container(
            height: screenSize.height * 0.9,
            width: screenSize.width * 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StatefulBuilder(
                builder: (context, setState) => Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        crossAxisCount: 2,
                        children: _profilePicsFiles
                            .map((e) => InkResponse(
                                  onTap: () {
                                    if (usuario.chems! <
                                        _chemsRequiredForPic[e]!) return;
                                    print("tapped ${e}");
                                    setState(() => _selectedProfilePic = e);
                                  },
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        //radius: 50,
                                        minRadius: 50,
                                        backgroundImage:
                                            AssetImage("imagenes/perfil/" + e),
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      _selectedProfilePic == e
                                          ? Container(
                                              //width: 100,
                                              //height: 100,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Palette.mainGreen
                                                    .withOpacity(0.5),
                                              ),
                                              child: Center(
                                                  child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                              )))
                                          : usuario.chems! <
                                                  _chemsRequiredForPic[e]!
                                              ? Container(
                                                  //width: 100,
                                                  //height: 100,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey[900]!
                                                        .withOpacity(0.5),
                                                  ),
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.lock,
                                                    color: Colors.white,
                                                  )))
                                              : Container()
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    ).then((value) {
      if (value != null) {
        setState(() {
          usuario.foto = value;
        });
      }
    });
  }

  ///Tapabble current profile picture that opens selector
  _showImageInput(BuildContext context) {
    return InkResponse(
      onTap: () => _pickProfilePicture(context),
      child: Stack(
        children: [
          UserAvatar(
              foto: usuario.foto ?? "regular.png", width: 112, height: 112),
          Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.mainGreen.withOpacity(0.3),
              ),
              child: Center(
                  child: Icon(
                Icons.edit,
                color: Colors.white,
              ))),
        ],
      ),
    );
  }

  Widget carreraChipWrap() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: carreras
            .map((e) => _buildChip(e.nombre, Color(e.color).withOpacity(1)))
            .toList(),
      ),
    );
  }

  ///Builds carrera input chip
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
}
