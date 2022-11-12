import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/pantallas/inicio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AsesoriaSettings extends StatefulWidget {
  final Asesoria asesoria;
  const AsesoriaSettings({Key? key, required this.asesoria}) : super(key: key);

  @override
  _EditAsesoriaPageState createState() => _EditAsesoriaPageState(asesoria);
}

class _EditAsesoriaPageState extends State<AsesoriaSettings> {
  Asesoria asesoria;
  //UI controllers
  bool _submitting = false;
  bool _error = false;
  _EditAsesoriaPageState(this.asesoria);

  void _attemptToUpdate() async {
    setState(() {
      _submitting = true;
    });
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

  Future<void> _borrarAsesoria() async {
    try {
      await AsesoriaBloc().borrarAsesoria(asesoria: asesoria);
      //Clear stack and go to inicio
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Inicio(),
        ),
        (route) => false,
      );
    } catch (e) {
      print(e);
      showSnack(context: context, text: "Unu no se pudo borrar la asesoría");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ajustes de Asesoría"),
          actions: [
            TextButton(
                onPressed: _attemptToUpdate,
                child: Text(
                  "Guardar",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  _showVisibleSwitch(),
                  Divider(),
                  _borrarTile(),
                  SizedBox(height: 32),
                  Text("Oprime 'Guardar' para efectuar cualquier cambio")
                ],
              ),
            ),
          ),
        ));
  }

  Widget _showVisibleSwitch() {
    return SwitchListTile(
        title: Text("Visibilidad"),
        subtitle: asesoria.visible!
            ? Text("Tus compañeros pueden ver tu asesoría")
            : Text("Solo tu puedes ver tu asesoría"),
        value: asesoria.visible!,
        onChanged: (value) {
          setState(() {
            asesoria.visible = !asesoria.visible!;
          });
        });
  }

  Widget _borrarTile() {
    return ListTile(
        title: Text(
          "Borrar Asesoría",
          style: TextStyle(color: Colors.red),
        ),
        minLeadingWidth: 0,
        leading: Icon(
          Icons.delete,
          color: Colors.red,
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
                        Text("Borrar Asesoría",
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    content: Text(
                        "¿Estás seguro que quieres borrar tu asesoría? Se borrará de forma permanente"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cancelar")),
                      TextButton(
                          onPressed: _borrarAsesoria,
                          child: Text("Borrar Asesoría",
                              style: TextStyle(color: Colors.red))),
                    ])));
  }
}
