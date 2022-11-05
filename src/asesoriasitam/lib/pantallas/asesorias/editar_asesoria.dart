import 'dart:io';

import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
  //UI controllers
  bool _submitting = false;
  bool _error = false;
  _EditAsesoriaPageState(this.asesoria);
  @override
  void initState() {
    showWa = asesoria.wa != null;
    showTel = asesoria.tel != null;
    super.initState();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _showDetallesInput(),
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
        ));
  }

  ///Selecciona, recorta y sube imagen.
  Future<void> seleccionarImagen() async {
    final _picker = ImagePicker();
    PickedFile? image = await _picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    /*
    if (image != null) {
      File? c = await ImageCropper.cropImage(
        sourcePath: image.path,
        maxWidth: 1080,
        maxHeight: 1080,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: "Recorta tu imagen",
          backgroundColor: Colors.white,
          activeControlsWidgetColor: Palette.mainGreen,
        ),
      );
      if (c != null) {
        setState(() {
          _cropped = c;
        });
      }
      
    }
    */
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
