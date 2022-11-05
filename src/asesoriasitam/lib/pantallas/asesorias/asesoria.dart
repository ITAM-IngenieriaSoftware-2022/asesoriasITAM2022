import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/pantallas/asesorias/ajustes_asesoria.dart';
import 'package:asesoriasitam/pantallas/asesorias/editar_asesoria.dart';
import 'package:asesoriasitam/pantallas/perfil/perfil.dart';
import 'package:asesoriasitam/utils/reportar.dart';
import 'package:asesoriasitam/widgets/userAvatar.dart';
import 'package:flutter/material.dart';

class AsesoriaPage extends StatefulWidget {
  final Asesoria asesoria;
  const AsesoriaPage({Key? key, required this.asesoria}) : super(key: key);

  @override
  _AsesoriaPageState createState() => _AsesoriaPageState(asesoria);
}

class _AsesoriaPageState extends State<AsesoriaPage> {
  Asesoria asesoria;
  late Usuario usuario;
  bool miAsesoria = false;
  bool _recomendado = true;

  _AsesoriaPageState(this.asesoria);

  @override
  void initState() {
    usuario = Global.usuario!;
    miAsesoria = usuario.uid == widget.asesoria.porUsuario;
    _recomendado = widget.asesoria.recomendadoPor!.contains(usuario.uid);
    super.initState();
  }

  Future<void> _update() async {
    try {
      Asesoria _temp = await AsesoriaBloc().getAsesoria(uid: asesoria.uid!);
      setState(() {
        asesoria = _temp;
        _recomendado = asesoria.recomendadoPor!.contains(usuario.uid);
      });
    } catch (e) {
      showSnack(context: context, text: "Unu error consiguiendo asesoria");
      print("Couldnt update asesoria: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          !asesoria.visible!
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.visibility_off),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.visibility),
                ),
          miAsesoria ? _editButton() : Container(),
          miAsesoria ? _settingsButton() : Container(),
          !miAsesoria
              ? IconButton(
                  onPressed: () => showReportar(
                      context: context, data: asesoria.toMap(asesoria)),
                  icon: Icon(Icons.more_vert))
              : Container(),
        ],
      ),
      body: _mainColumn(),
    );
  }

  Widget _editButton() {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          bool? updated = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditAsesoriaPage(asesoria: asesoria)),
          );
          if (updated == true) {
            _update();
          }
        });
  }

  Widget _settingsButton() {
    return IconButton(
        icon: Icon(Icons.settings),
        onPressed: () async {
          bool? updated = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AsesoriaSettings(asesoria: asesoria)),
          );
          if (updated == true) {
            _update();
          }
        });
  }

  Widget _mainColumn() {
    final scaffColor = Theme.of(context).scaffoldBackgroundColor;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Palette.mainGreen,
            child: Column(
              children: [
                SizedBox(height: 8),
                //Ofreciada por usuario chip
                Text(
                  "Asesoría ofrecida por",
                  style: TextStyle(color: scaffColor, fontSize: 18),
                ),
                SizedBox(height: 8),
                InputChip(
                  label: Text(asesoria.nombreCompletoUsuario!,
                      style: TextStyle(fontSize: 18, color: Palette.mainBrown)),
                  backgroundColor: Palette.mainYellow,
                  avatar: UserAvatar(
                      foto: asesoria.usuarioFoto!, width: 32, height: 32),
                  onPressed: () => goto(
                      context,
                      Perfil(
                        usuarioUid: asesoria.porUsuario!,
                      )),
                ),
                //Clases
                SizedBox(height: 8),
                Text(
                  "Para " + asesoria.clase!,
                  style: TextStyle(color: scaffColor, fontSize: 18),
                ),
                SizedBox(
                  height: 8,
                ),
                // asesoria.recomendadoPorN > 0
                true
                    ? Text(
                        asesoria.recomendadoPorN.toString() +
                            " recomendaciones",
                        style: TextStyle(
                          color: scaffColor,
                          fontSize: 18,
                        ),
                      )
                    : Container(),
                InkWell(
                    onTap: () async {
                      try {
                        _recomendado
                            ? await AsesoriaBloc().desrecomendarAsesoria(
                                asesoria: asesoria, usuario: usuario)
                            : await AsesoriaBloc().recomendarAsesoria(
                                asesoria: asesoria, usuario: usuario);
                        _update();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      _recomendado
                          ? "Dejar de recomendar"
                          : "Recomienda esta asesoría",
                      style: TextStyle(
                        color: Palette.mainYellow,
                        fontSize: 18,
                      ),
                    )),

                SizedBox(
                  height: 24,
                )
              ],
            ),
          ),
          SizedBox(height: 16),
          //Imagen
          //asesoria.imagenUrl != null ? _image() : Container(),

          //Descripcion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                    title: Text(asesoria.detalles!),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text("Descripción"),
                    )),
              ),
            ),
          ),

          //Contacto
          SizedBox(height: 16),
          asesoria.wa != null
              ? ListTile(
                  title: Text(asesoria.wa!.split("/").last),
                  subtitle: Row(
                    children: [
                      Text("WhatsApp"),
                      SizedBox(width: 4),
                      Icon(
                        Icons.open_in_new,
                        color: Colors.grey,
                        size: 14,
                      )
                    ],
                  ),
                  onTap: () => launchURL(asesoria.wa!),
                )
              : Container(),
          asesoria.tel != null
              ? ListTile(
                  title: Text(asesoria.tel!),
                  subtitle: Text("Teléfono"),
                  onTap: () {},
                )
              : Container(),
          asesoria.mail != null
              ? ListTile(
                  title: Text(asesoria.mail!),
                  subtitle: Row(
                    children: [
                      Text("Correo"),
                      SizedBox(width: 4),
                      Icon(
                        Icons.open_in_new,
                        color: Colors.grey,
                        size: 14,
                      )
                    ],
                  ),
                  onTap: () => launchURLToMail(mail: asesoria.mail!),
                )
              : Container(),
        ],
      ),
    );
  }
  /*
  Widget _image() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Image.network(asesoria.imagenUrl!)),
    );
  }
  */
}
