import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/comentario.dart';
import 'package:asesoriasitam/db/comentario_bloc.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/utils/usefulWidgets.dart';
import 'package:asesoriasitam/widgets/actionButton.dart';
import 'package:asesoriasitam/widgets/screens/loading.dart';
import 'package:asesoriasitam/widgets/textInput.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ComentarAsesoriaPage extends StatefulWidget {
  final Asesoria asesoria;
  const ComentarAsesoriaPage({Key? key, required this.asesoria})
      : super(key: key);

  @override
  _ComentarAsesoriaPageState createState() =>
      _ComentarAsesoriaPageState(asesoria);
}

class _ComentarAsesoriaPageState extends State<ComentarAsesoriaPage> {
  late Asesoria asesoria;
  final _formKey = GlobalKey<FormState>();
  late PlatformFile file;

  // Comentario
  late Comentario comentario;
  late bool _recomiendoOld;

  // UI controllers
  bool _submitting = false;
  bool _error = false;
  bool _gotComentario = false;
  bool _comentarioExistente = false;

  _ComentarAsesoriaPageState(this.asesoria);

  @override
  void initState() {
    super.initState();
    _getComentario();
  }

  void _getComentario() async {
    Comentario _comentario = Comentario();
    bool _e = false;
    try {
      _comentario = await ComentarioBloc()
          .getComentarioByUsuario(asesoria, Global.usuario!.uid!);
      print(
          "Se encontro comentario existente: ${_comentario.toMap(_comentario)}");

      // Guardamos recomeiendo viejo
      _recomiendoOld = _comentario.recomiendo!;
      _e = true;
    } catch (e) {
      // No se obtuvo el comentario
      print("No se encontro comentario existente");
      print(e);
      _comentario.uid = Uuid().v1();
      _comentario.nombreCompletoUsuario = Global.usuario!.nombreCompleto();
      _comentario.porUsuario = Global.usuario!.uid;
      _comentario.usuarioFoto = Global.usuario!.foto ?? "regular.png";
      _comentario.texto = "";
      _comentario.recomiendo = true;
      _comentario.asesoriaUid = asesoria.uid;
      _comentario.subido = DateTime.now();
    }
    setState(() {
      _gotComentario = true;
      comentario = _comentario;
      _comentarioExistente = _e;
    });
  }

  void _recomendar() async {
    final _form = _formKey.currentState;
    if (_form!.validate()) {
      _form.save();
      setState(() {
        _submitting = true;
      });
      try {
        await AsesoriaBloc()
            .calificarAsesoria(asesoria: asesoria, comentario: comentario);
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

  void _editarRecomendacion() async {
    final _form = _formKey.currentState;
    if (_form!.validate()) {
      _form.save();
      setState(() {
        _submitting = true;
      });
      try {
        await AsesoriaBloc().actualizarCalificacion(
            asesoria: asesoria,
            comentario: comentario,
            recomiendoOld: _recomiendoOld);
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

  void _desrecomendar() async {
    try {
      await AsesoriaBloc()
          .descalificarAsesoria(asesoria: asesoria, comentario: comentario);
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
              : Text("Califica Asesoría"),
          leading: CloseButton(),
          actions: [
            IconButton(onPressed: _desrecomendar, icon: Icon(Icons.delete))
          ],
          centerTitle: _submitting,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: CenteredConstrainedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CenteredConstrainedBox(
                  child: _gotComentario
                      ? Column(
                          children: [
                            SizedBox(height: 32),
                            _recomiendaInput(),
                            _comentarioInput(),
                            SizedBox(height: 32),
                            _comentarioExistente
                                ? CustomActionButton(
                                    text: "Editar calificación",
                                    onPressed: _editarRecomendacion,
                                    isSubmitting: _submitting,
                                  )
                                : CustomActionButton(
                                    text: "Calificar",
                                    onPressed: _recomendar,
                                    isSubmitting: _submitting,
                                  ),
                            SizedBox(height: 16),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                              SizedBox(
                                height: 64,
                              ),
                              Center(child: CircularProgressIndicator())
                            ]),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _recomiendaInput() {
    return SwitchListTile(
        title: Text("¿Recomiendas al asesxr?"),
        subtitle: comentario.recomiendo!
            ? Text("Sí recomiendo al asesxr")
            : Text("No recomiendo al asesxr"),
        value: comentario.recomiendo!,
        onChanged: (value) {
          setState(() {
            comentario.recomiendo = !comentario.recomiendo!;
          });
        });
  }

  Widget _comentarioInput() {
    return CustomTextInput(
      labelText: "Comentario",
      keyboardType: TextInputType.multiline,
      maxLength: 300,
      maxLines: null,
      initialText: comentario.texto,
      onChanged: (val) => setState(() => comentario.texto = val),
      onSaved: (val) => comentario.texto = val,
      validator: (val) =>
          val!.trim().isEmpty ? "Por favor ingresa un comentario" : null,
    );
  }
}
