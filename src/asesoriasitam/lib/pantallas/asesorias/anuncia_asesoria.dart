import 'dart:io';

import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/clase_bloc.dart';
import 'package:asesoriasitam/db/clases/clase.dart';
import 'package:asesoriasitam/db/clases/lugar.dart';
import 'package:asesoriasitam/db/lugar_bloc.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/widgets/actionButton.dart';
import 'package:asesoriasitam/widgets/textInput.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../db/clases/asesoria.dart';
import '../../db/clases/usuario.dart';

class AnunciaAsesoria extends StatefulWidget {
  final Usuario usuario;
  AnunciaAsesoria({Key? key, required this.usuario}) : super(key: key);
  @override
  _AnunciaAsesoriaState createState() => _AnunciaAsesoriaState(usuario);
}

class _AnunciaAsesoriaState extends State<AnunciaAsesoria> {
  //Form
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  //Data
  Usuario usuario;
  Asesoria asesoria = Asesoria();
  String depto = Global.departamentos.first;

  // Clases de depto
  List<String> clasesDeDepto = [];
  bool gotClasesDeDepto = false;

  // Lugares
  List<Lugar> lugares = [];
  bool gotLugares = false;

  bool showWa = true;
  bool showTel = true;
  final DateTime timestamp = DateTime.now();
  late PlatformFile file;
  File? _cropped;

  //Control UI
  bool _submitting = false;
  bool _error = false;
  bool _missingFields = false;
  bool _subido = false;

  // Otros
  List<String> diasOrdenados = ['LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'];

  _AnunciaAsesoriaState(this.usuario);

  Future<void> _attemptToRegister() async {
    final _form = _formKey.currentState;
    if (_form!.validate() && asesoria.clase!.isNotEmpty) {
      _form.save();
      setState(() {
        _submitting = true;
      });
      try {
        await AsesoriaBloc().subirAsesoria(asesoria: asesoria);
        setState(() {
          _submitting = false;
          _subido = true;
        });
      } catch (e) {
        print(e);
        setState(() {
          _submitting = false;
          _error = true;
        });
      }
    } else {
      setState(() {
        _missingFields = true;
      });
      showSnack(context: context, text: "Revisa los datos ingresados");
    }
  }

  Future<void> _getClasesDeDepto(String depto) async {
    print("Intentando conseguir clases de $depto...");
    clasesDeDepto = [];
    try {
      List<Clase> nuevos = await ClaseBloc().getClasesByDepto(depto: depto);
      List<String> nuevosStr = nuevos.map((e) => e.nombre).toList();
      setState(() {
        clasesDeDepto = nuevosStr;
        gotClasesDeDepto = true;
        asesoria.clase = clasesDeDepto.isEmpty ? "" : clasesDeDepto.first;
        print("Got ${clasesDeDepto.length} clases de ${depto}");
      });
    } catch (e) {
      print("Error consiguiendo clases de $depto:");
      print(e);
    }
  }

  Future<void> _getLugares() async {
    print("Intentando conseguir lugares...");
    lugares = [];
    try {
      List<Lugar> nuevos = await LugarBloc().getLugares();
      //List<String> nuevosStr = nuevos.map((e) => e.nombre).toList();
      setState(() {
        lugares = nuevos;
        gotLugares = true;
        print("Got lugares:$lugares");
      });
    } catch (e) {
      print("Error consiguiendo lugares:");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //_get_clases()
    asesoria.uid = Uuid().v1();
    asesoria.nombreCompletoUsuario = usuario.nombreCompleto();
    asesoria.porUsuario = usuario.uid;
    asesoria.detalles = "";
    asesoria.usuarioFoto = usuario.foto;
    asesoria.clase = "";
    asesoria.mail = usuario.correo;
    asesoria.tel = usuario.tel;
    asesoria.wa = "";
    asesoria.visible = true;
    asesoria.baneado = false;
    asesoria.recomendadoPor = [];
    asesoria.lugares = [];
    asesoria.recomendadoPorN = 0;
    asesoria.precio = 0;
    asesoria.horario = {
      'LU': '',
      'MA': '',
      'MI': '',
      'JU': '',
      'VI': '',
      'SA': '',
      'DO': ''
    };
    _getClasesDeDepto(depto);
    _getLugares();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Anunciar Asesoría"),
          elevation: 0,
        ),
        body: _showCorrespondingWidget());
  }

  Widget _showCorrespondingWidget() {
    if (_submitting) {
      return _messagePage(
          top: "Registrando tu asesoría",
          bottom: "Puede que tarde un poco.\nGracias x tu paciencia uwu",
          center: Container(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ));
    } else if (_subido) {
      return _messagePage(
          top: "UwU\nRegistro exitoso",
          bottom:
              "Tu asesoría ha sido creada exitosamente!\nPuedes verla en tu perfil o en cada una de las clases que seleccionaste :)",
          center: Icon(Icons.check_circle_sharp,
              color: Theme.of(context).primaryColor, size: 50));
    } else if (_error) {
      return _messagePage(
          top: "UnU\nSe produjo un error",
          bottom:
              "Se produjo un error al intentar registrar tu asesoría. Lo siento toy chiquito.",
          center: Icon(Icons.error, color: Colors.red, size: 50));
    } else {
      return _formPage();
    }
  }

  Widget _messagePage(
      {required String top, required String bottom, required Widget center}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(top,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(padding: const EdgeInsets.all(24.0), child: center),
            Text(
              bottom,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formPage() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Anuncia tus asesorías",
                          style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 16),
                      Text(
                        "Anuncia tus asesorías en las páginas de materias y en tu perfil. Gratis en beta :)",
                      ),
                    ],
                  ),
                ),
                Stepper(
                    physics: ClampingScrollPhysics(),
                    currentStep: _currentStep,
                    controlsBuilder: (context, ControlsDetails controls) =>
                        _nextChecker()
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _currentStep += 1;
                                        print("Step: $_currentStep");
                                      });
                                    },
                                    child: Text("SIGUIENTE",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColor))),
                              )
                            : Container(),
                    onStepTapped: (step) {
                      setState(() {
                        _currentStep = step;
                      });
                    },
                    steps: [
                      _clasesStep(),
                      _horarioStep(),
                      _lugaresStep(),
                      _descripcionStep(),
                      _contactoStep(),
                    ]),
                _currentStep == 4
                    ? Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: CustomActionButton(
                          text: "Registrar Asesoría",
                          isSubmitting: _submitting,
                          onPressed: _attemptToRegister,
                        ))
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _nextChecker() {
    if (_currentStep >= 4)
      return false;
    else if (_currentStep == 0) // Clase step
      return asesoria.clase!.isNotEmpty;
    else if (_currentStep == 1) // Horario step
      return true;
    else if (_currentStep == 2) // Lugares step
      return asesoria.lugares!.isNotEmpty;
    else if (_currentStep == 3) // Descripcion
      return asesoria.detalles!.isNotEmpty;
    return false;
  }

  ///Step title and description
  Widget _stepText(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title + '\n',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(description)
      ],
    );
  }

  ///Gets step editing/complete/disabled state
  StepState _stepState(int i) {
    if (_currentStep == i)
      return StepState.editing;
    else if (_currentStep > i)
      return StepState.complete;
    else
      return StepState.disabled;
  }

  //Steps

  Widget _claseSelector() {
    if (gotClasesDeDepto && clasesDeDepto.isNotEmpty) {
      return DropdownButton(
        isExpanded: true,
        value: asesoria.clase,
        items: clasesDeDepto.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (String? value) => setState(() {
          asesoria.clase = value;
          print("Valor de asesoria.clase = $asesoria.clase");
        }),
        elevation: 2,
      );
    } else if (gotClasesDeDepto && clasesDeDepto.isEmpty) {
      return Text("No se encontraron clases para ese departamento");
    } else {
      return CircularProgressIndicator();
    }
  }

  Step _clasesStep() {
    return Step(
        title: Text("Clase(s)"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _stepText("Selecciona la clase para la que darás asesorías",
                "Selecciona el departamento de la materia y déspues la materia"),
            SizedBox(height: 16),
            DropdownButton(
              value: depto,
              items: Global.departamentos
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) => setState(() {
                depto = value!;
                gotClasesDeDepto = false;
                _getClasesDeDepto(value);
              }),
              elevation: 2,
            ),
            SizedBox(height: 32),
            _claseSelector(),
            SizedBox(height: 16)
          ],
        ),
        isActive: true,
        state: _stepState(0));
  }

  Step _horarioStep() {
    //TODO incluye horarios, lugares y precio
    List<Widget> content = [
      _stepText(
          "¿Qué horarios tienes disponibles para dar asesorias de esta clase?",
          "Llena tu horario para cada día de la semana. Deja la caja vacía si no darás asesorías ese dia:"),
      SizedBox(height: 16)
    ];
    content.addAll(diasOrdenados
        .map((e) => CustomTextInput(
              labelText: "Horario para $e. Ej. 9:00-11:00, 14:00-15:00",
              onChanged: (val) => asesoria.horario?[e] = val,
              onSaved: (val) => asesoria.horario?[e] = val,
              maxLength: 42,
            ))
        .toList());
    return Step(
        title: Text("Horarios"),
        content: Column(children: content),
        isActive: true,
        state: _stepState(1));
  }

  Step _lugaresStep() {
    List<Widget> content = [
      _stepText("¿Dónde darás tus asesorías?",
          "Selecciona en dónde planeas dar tus asesorías"),
      SizedBox(height: 16),
      lugaresChipWrap(),
    ];
    return Step(
        title: Text("Lugares"),
        content: Column(children: content),
        isActive: true,
        state: _stepState(2));
  }

  Widget lugaresChipWrap() {
    if (gotLugares && lugares.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: lugares
              .map((e) => _buildChip(e.nombre,
                  Palette.mainGreen)) //Color(e.color).withOpacity(1)))
              .toList(),
        ),
      );
    } else if (gotLugares && lugares.isEmpty) {
      return Text(
          "No se encontraron lugares. Puedes agregarlos después editando la asesoría.");
    } else {
      return CircularProgressIndicator();
    }
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
      selected: asesoria.lugares!.contains(text),
      onPressed: () {
        print("Se selecciono el lugar $text");
        if (!asesoria.lugares!.contains(text)) {
          setState(() {
            asesoria.lugares!.add(text);
          });
          print("Se le agrego (localmente) el lugar $text a la asesoria");
          print("Lugares: ${asesoria.lugares}");
        } else {
          setState(() {
            asesoria.lugares!.remove(text);
          });
          print("Se le elimino (localmente) el lugar $text de la asesoria");
          print("Lugares: ${asesoria.lugares}");
        }
      },
    );
  }

  Step _descripcionStep() {
    return Step(
        title: Text("Descripción"),
        content: Column(
          children: [
            _stepText("Llena la descripción de tu anuncio",
                "Explícales a tus compañeros porque eres buen asesor o detalles de tus asesorías"),
            SizedBox(height: 16),
            CustomTextInput(
              labelText: "Detalles",
              keyboardType: TextInputType.multiline,
              maxLength: 500,
              maxLines: null,
              onChanged: (val) => setState(() => asesoria.detalles = val),
              onSaved: (val) => asesoria.detalles = val,
              validator: (val) =>
                  val!.isEmpty ? "Ingresa los detalles de tu asesoría" : null,
            ),
            SizedBox(height: 16),
            CustomTextInput(
              labelText: "Precio/Hr en pesos (Ingresa 0 si será gratuito)",
              keyboardType: TextInputType.number,
              onChanged: (val) =>
                  setState(() => asesoria.precio = double.parse(val!)),
              onSaved: (val) => asesoria.precio = double.parse(val!),
              validator: (val) => !isNumeric(val!)
                  ? "Debe ser un numero. Ingresa 0 si será gratuito."
                  : null,
            ),
          ],
        ),
        isActive: true,
        state: _stepState(3));
  }

  Step _contactoStep() {
    return Step(
        title: Text("Información de Contacto"),
        content: Column(
          children: [
            _stepText("Llena tu información de contacto",
                "¿Cómo quieres que te contacten tus compañeros si están interesados o tienen dudas?"),
            SizedBox(height: 16),
            //Correo
            CustomTextInput(
              labelText: "Correo",
              initialText: asesoria.mail,
              onSaved: (val) => asesoria.mail = val,
              validator: (val) => (val!.length == 0 && val.contains("@"))
                  ? "Ingresa Correo"
                  : null,
              suffixIcon: Icons.mail,
            ),
            SizedBox(height: 8),
            //Switches
            SwitchListTile(
              title: Text("Mostrar teléfono"),
              value: showTel,
              onChanged: (bool value) {
                setState(() {
                  showTel = value;
                  showWa = showTel ? showWa : false;
                });
              },
              secondary: Icon(Icons.phone),
            ),
            SwitchListTile(
              title: Text("Mostrar link WA"),
              value: showWa,
              onChanged: (bool value) {
                setState(() {
                  showWa = value;
                  showTel = showWa ? true : showTel;
                });
              },
              secondary: Icon(Icons.link),
            ),
            //Tel
            showTel
                ? CustomTextInput(
                    labelText: "Teléfono",
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    initialText: asesoria.tel,
                    suffixIcon: Icons.phone,
                    onSaved: (val) {
                      asesoria.wa = showWa ? "https://wa.me/${val}" : null;
                      asesoria.tel = val;
                    },
                    onChanged: (val) {
                      setState(() {
                        asesoria.tel = val;
                      });
                    },
                    validator: (value) => (showTel && value!.length == 0)
                        ? "Ingrese Teléfono"
                        : null,
                  )
                : Container(),
            //WA
            (showTel && showWa)
                ? ListTile(
                    title: Text("Link WA (Click para probar)"),
                    subtitle: Text("https://wa.me/${asesoria.tel}"),
                    trailing: Icon(Icons.link),
                    onTap: () => launchURL("https://wa.me/${asesoria.tel}"),
                  )
                : Container(), //switch
          ],
        ),
        isActive: true,
        state: _stepState(4));
  }
}
