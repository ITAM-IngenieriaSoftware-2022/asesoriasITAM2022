import 'dart:io';

import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/lugar.dart';
import 'package:asesoriasitam/db/lugar_bloc.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/widgets/textInput.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditAsesoriaPage extends StatefulWidget {
  final Asesoria asesoria;
  const EditAsesoriaPage({Key? key, required this.asesoria}) : super(key: key);

  @override
  _EditAsesoriaPageState createState() => _EditAsesoriaPageState(asesoria);
}

class _EditAsesoriaPageState extends State<EditAsesoriaPage> {
  late Asesoria asesoria;
  final _formKey = GlobalKey<FormState>();
  late PlatformFile file;
  File? _cropped;
  late bool showWa;
  late bool showTel;

  // Lugares
  List<Lugar> lugares = [];
  bool gotLugares = false;

  // UI controllers
  bool _submitting = false;
  bool _error = false;
  _EditAsesoriaPageState(this.asesoria);

  // Otros
  List<String> diasOrdenados = ['LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'];

  @override
  void initState() {
    showWa = asesoria.wa != null;
    showTel = asesoria.tel != null;
    super.initState();
    _getLugares();
  }

  void _attemptToUpdate() async {
    final _form = _formKey.currentState;
    if (_form!.validate()) {
      _form.save();
      setState(() {
        _submitting = true;
      });
      var _c = _cropped;
      if (_c != null) {
        try {
          await AsesoriaBloc().updateAsesoria(asesoria: asesoria);
          setState(() {
            Navigator.pop(context, true);
          });
        } catch (e) {
          print(e);
          setState(() {
            _submitting = false;
            _error = true;
          });
        }
      } else {
        try {
          await AsesoriaBloc().updateAsesoria(asesoria: asesoria);
          setState(() {
            Navigator.pop(context, true);
          });
        } catch (e) {
          print(e);
          setState(() {
            _submitting = false;
            _error = true;
          });
        }
      }
    }
  }

  Future<void> _getLugares() async {
    print("Intentando conseguir lugares...");
    lugares = [];
    try {
      List<Lugar> nuevos = await LugarBloc().getLugares();
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _submitting
              ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ))
              : Text("Editar Asesoría"),
          leading: CloseButton(),
          centerTitle: _submitting,
          actions: [
            _submitting
                ? Container()
                : IconButton(
                    onPressed: _attemptToUpdate, icon: Icon(Icons.check))
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      _showHorarioInput(),
                      _showLugaresInput(),
                      _showDetallesInput(),
                      _showPrecioInput(),
                      _showMailInput(),
                      _showTelSwitch(),
                      _showWaSwitch(),
                      showTel ? _showTelInput() : Container(),
                      (showTel && showWa) ? _showWaLink() : Container(),
                      SizedBox(height: 32)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _showHorarioInput() {
    List<Widget> content = [
      SizedBox(height: 32),
      Text(
          "Llena tu horario para cada día de la semana. Deja la caja vacía si no darás asesorías ese dia:"),
      SizedBox(height: 32)
    ];
    content.addAll(diasOrdenados
        .map((e) => CustomTextInput(
              labelText: "Horario para $e. Ej. 9:00-11:00, 14:00-15:00",
              onChanged: (val) => asesoria.horario?[e] = val,
              onSaved: (val) => asesoria.horario?[e] = val,
              initialText: asesoria.horario?[e],
              maxLength: 42,
            ))
        .toList());
    return Column(children: content);
  }

  Widget _showLugaresInput() {
    return lugaresChipWrap();
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

  _showDetallesInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
          initialValue: asesoria.detalles,
          keyboardType: TextInputType.multiline,
          maxLength: 500,
          maxLines: null,
          onSaved: (val) => asesoria.detalles = val!,
          validator: (val) =>
              val!.length == 0 ? "Ingresa los detalles de tu asesoría" : null,
          decoration: InputDecoration(
            labelText: "Detalles",
            hintText: "Detalles",
            //helperText: "Ingresa una descripcion util",
          )),
    );
  }

  Widget _showPrecioInput() {
    return CustomTextInput(
      labelText: "Precio/Hr en pesos (Ingresa 0 si será gratuito)",
      keyboardType: TextInputType.number,
      initialText: asesoria.precio.toString(),
      onChanged: (val) => setState(() => asesoria.precio = double.parse(val!)),
      onSaved: (val) => asesoria.precio = double.parse(val!),
      validator: (val) => !isNumeric(val!)
          ? "Debe ser un numero. Ingresa 0 si será gratuito."
          : null,
    );
  }

  _showMailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        initialValue: asesoria.mail,
        onSaved: (val) => asesoria.mail = val,
        validator: (val) =>
            (val!.length == 0 && val.contains("@")) ? "Ingresa Correo" : null,
        decoration:
            InputDecoration(labelText: "Correo", suffixIcon: Icon(Icons.mail)),
      ),
    );
  }

  _showTelSwitch() {
    return SwitchListTile(
      title: Text("Mostrar teléfono"),
      value: showTel,
      onChanged: (bool value) {
        setState(() {
          showTel = value;
          showWa = showTel ? showWa : false;
        });
      },
      secondary: Icon(Icons.phone),
    );
  }

  _showWaSwitch() {
    return SwitchListTile(
      title: Text("Mostrar link WA"),
      value: showWa,
      onChanged: (bool value) {
        setState(() {
          showWa = value;
          showTel = showWa ? true : showTel;
        });
      },
      secondary: Icon(Icons.link),
    );
  }

  _showTelInput() {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        initialValue: asesoria.tel,
        onSaved: (val) {
          asesoria.wa = showWa ? "https://wa.me/${val}" : null;
          asesoria.tel = val;
        },
        onChanged: (val) {
          setState(() {
            asesoria.tel = val;
          });
        },
        validator: (value) =>
            (showTel && value!.length == 0) ? "Ingrese Teléfono" : null,
        decoration: InputDecoration(
            labelText: "Teléfono",
            hintText: "Teléfono",
            suffixIcon: Icon(Icons.phone)),
      ),
    );
  }

  _showWaLink() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: ListTile(
          title: Text("Link WA (Click para probar)"),
          subtitle: Text("https://wa.me/${asesoria.tel}"),
          trailing: Icon(Icons.link),
          onTap: () => launchURL("https://wa.me/${asesoria.tel}"),
        ));
  }
}
