import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/comentario.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/pantallas/asesorias/comentar.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/pantallas/asesorias/ajustes_asesoria.dart';
import 'package:asesoriasitam/pantallas/asesorias/editar_asesoria.dart';
import 'package:asesoriasitam/pantallas/perfil/perfil.dart';
import 'package:asesoriasitam/utils/reportar.dart';
import 'package:asesoriasitam/utils/usefulWidgets.dart';
import 'package:asesoriasitam/widgets/generalListView.dart';
import 'package:asesoriasitam/widgets/userAvatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AsesoriaPage extends StatefulWidget {
  final Asesoria asesoria;
  const AsesoriaPage({Key? key, required this.asesoria}) : super(key: key);

  @override
  _AsesoriaPageState createState() => _AsesoriaPageState(asesoria);
}

class _AsesoriaPageState extends State<AsesoriaPage> {
  // Critical
  Asesoria asesoria;
  late Usuario usuario;
  bool miAsesoria = false;
  bool _recomendado = true;

  // Comentarios
  late GeneralPaginatedListView comentarios;

  // Otros
  List<String> diasOrdenados = ['LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'];

  _AsesoriaPageState(this.asesoria);

  @override
  void initState() {
    usuario = Global.usuario!;
    miAsesoria = usuario.uid == widget.asesoria.porUsuario;
    _recomendado = widget.asesoria.recomendadoPor!.contains(usuario.uid);

    comentarios = GeneralPaginatedListView(
        before: [
          _mainColumn()
        ],
        after: [
          SizedBox(
            height: 48,
          )
        ],
        query: FirebaseFirestore.instance
            .collection('asesorias')
            .doc(asesoria.uid)
            .collection('comentarios'),
        resultObject: Comentario(),
        displayType: ResultDisplayType.tile,
        noDataMessage: "Todavía no hay comentarios en esta asesoría");

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
        body: comentarios //_mainColumn(),
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
    //final scaffColor = Theme.of(context).scaffoldBackgroundColor;
    return SingleChildScrollView(
      child: Column(
        //SingleChildScrollView
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
                  style:
                      TextStyle(color: Colors.white, fontSize: 18), //scaffColor
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
                // Clase
                SizedBox(height: 8),
                Text(
                  "Para " + asesoria.clase!,
                  style:
                      TextStyle(color: Colors.white, fontSize: 18), //scaffColor
                ),
                SizedBox(
                  height: 8,
                ),
                // Precio
                Text(
                  "\$ " + asesoria.precio!.toString() + " /hr",
                  style:
                      TextStyle(color: Colors.white, fontSize: 18), //scaffColor
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
                          color: Colors.white, //scaffColor
                          fontSize: 18,
                        ),
                      )
                    : Container(),
                InkWell(
                    onTap: () =>
                        goto(context, ComentarAsesoriaPage(asesoria: asesoria)),
                    /*async {
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
                    },*/
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
                ),
              ],
            ),
          ),
          CenteredConstrainedBox(
              child: Column(
            children: [
              SizedBox(height: 16),
              //Imagen
              //asesoria.imagenUrl != null ? _image() : Container(),
              //Descripcion
              _sectionTitle(title: "Descripción"),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(asesoria.detalles ?? "No hay detalles"),
              ),
              _sectionTitle(title: "Horarios"),
              _horario(),

              //Contacto
              _sectionTitle(title: "Contacto"),
              asesoria.wa != null
                  ? ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(asesoria.wa!.split("/").last),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(asesoria.tel!),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Teléfono"),
                        ],
                      ),
                      onTap: () {},
                    )
                  : Container(),
              asesoria.mail != null
                  ? ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(asesoria.mail!),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
              _sectionTitle(title: "Comentarios")
            ],
          )),
          //comentarios.hasData ? Text("Comentarios") : Container(),
          //Expanded(child: comentarios)
        ],
      ),
    );
  }

  Widget _sectionTitle({required String title}) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 24.0, right: 24, top: 32, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  wordSpacing: 0.15)),
        ],
      ),
    );
  }

  Widget _horario() {
    List<Widget> out = [];
    double fontSize = 18;
    for (String dia in diasOrdenados) {
      String hrs = asesoria.horario![dia];
      if (hrs.isEmpty) continue;
      out.add(Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(children: [
          Text(
            dia,
            style: TextStyle(fontSize: fontSize),
          )
        ]),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              hrs,
              style: TextStyle(fontSize: fontSize),
            )
          ],
        )
      ]));
    }
    return CenteredConstrainedBox(maxWidth: 150, child: Column(children: out));
  }
}
