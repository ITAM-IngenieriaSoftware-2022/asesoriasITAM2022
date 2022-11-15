import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/usuario_bloc.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/pantallas/perfil/ajustes_perfil.dart';
import 'package:asesoriasitam/pantallas/perfil/editar_perfil.dart';
import 'package:asesoriasitam/utils/reportar.dart';
import 'package:asesoriasitam/widgets/cards/cards.dart';
import 'package:asesoriasitam/widgets/screens/loading.dart';
import 'package:asesoriasitam/widgets/screens/unu.dart';

import 'package:asesoriasitam/widgets/userAvatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Perfil extends StatefulWidget {
  final Usuario? usuario;
  final String? usuarioUid;
  Perfil({Key? key, this.usuario, this.usuarioUid}) : super(key: key);
  @override
  _PerfilState createState() => _PerfilState(usuario);
}

class _PerfilState extends State<Perfil> {
  //Data
  late Usuario? usuario, usuarioDispositivo;
  bool myPage = false;
  List<Map<String, dynamic>> _clases = [];
  List<Asesoria> asesorias = [];
  List<Map<String, dynamic>> _grupos = [];

  //UI controllers
  bool _loadingPage = false;
  bool _anyData = true;
  bool _error = false;

  @override
  _PerfilState(this.usuario);
  @override
  void initState() {
    usuarioDispositivo = Global.usuario;
    if (usuario == null || usuario?.grupos == null) {
      _loadingPage = true;
      _altInit();
    } else {
      _init();
    }
    super.initState();
  }

  void _init() async {
    var u = usuario;
    if (u != null) {
      myPage = usuarioDispositivo!.uid == u.uid;
      print(usuario!.nombre);
      _grupos = [];
      for (String grupoUid in u.grupos?.keys ?? {}) {
        dynamic grupoData = u.grupos?[grupoUid];
        _grupos.add({
          'uid': grupoUid,
          'nombre': grupoData['nombre'],
          'fotoUrl': grupoData['fotoUrl'],
          'soyAdmin': grupoData['soyAdmin']
        });
      }
      _clases = [];
      for (String claseUid in u.clases?.keys ?? {}) {
        dynamic claseData = usuario!.clases![claseUid];
        _clases.add({
          'uid': claseUid,
          'nombre': claseData['nombre'],
          'color': claseData['color']
        });
      }

      await _getAsesorias();
      anyData();
    }
  }

  void _altInit() async {
    print('alting... ${widget.usuarioUid} ${usuario?.uid}');
    await getUsuarioPagina(widget.usuarioUid ?? "");
    setState(() {
      _loadingPage = false;
    });
    _init();
  }

  _update() async {
    await getUsuarioPagina(usuario!.uid!);
    _init();
  }

  getUsuarioPagina(String usuarioUid) async {
    try {
      Usuario usr = await UsuarioBloc().getUserFromDB(uid: usuarioUid);
      setState(() {
        usuario = usr;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  getUsuarioDevice() async {
    Usuario usr =
        await UsuarioBloc().getUserFromDB(uid: usuarioDispositivo!.uid!);
    setState(() {
      usuarioDispositivo = usr;
    });
  }

  _getAsesorias() async {
    asesorias = [];
    try {
      List<Asesoria> nuevos = await AsesoriaBloc()
          .getAsesoriasByUsuario(usuarioUid: usuario!.uid!, onlyVisible: false);
      setState(() {
        asesorias = nuevos;
        print("GOT asesorias");
      });
    } catch (e) {
      print('error getting asesorias');
      print(e);
    }
  }

  bool anyData() {
    return _anyData =
        asesorias.length > 0 || _grupos.length > 0 || _clases.length > 0;
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingPage)
      return loadingScreen();
    else if (_error)
      return unuScreen(
          context: context, texto: "Error consiguiendo este usuario");
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: [
            myPage ? _editButton() : Container(),
            myPage ? _settingsButton() : _optionsButton()
          ],
        ),
        body: RefreshIndicator(
          notificationPredicate: (notification) {
            return true;
          },
          onRefresh: () {
            return _update();
          },
          child: SingleChildScrollView(
            child: _anyData
                ? Column(
                    children: [
                      _getHeader(),
                      _showAsesorias(context),
                      //_showGrupos(context),
                      //_showClases(context),
                      //_showArchivos(context),
                      SizedBox(height: 32)
                    ],
                  )
                : noDataColumn(),
          ),
        ));
  }

  Widget _showAsesorias(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32),
        Text("Tus Asesorias", style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 32),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              asesorias.map((e) => asesoriaCard(e, 250, 150, context)).toList(),
        ),
      ],
    );
  }

  Widget noDataColumn() {
    return Column(
      children: [
        _getHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 64),
              Text("UnU",
                  style: TextStyle(
                      fontSize: 50, color: Theme.of(context).hintColor)),
              Text("Todavía no tomas u ofreces asesorías",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _optionsButton() {
    return IconButton(
      icon: Icon(Icons.more_vert),
      onPressed: () =>
          showReportar(context: context, data: usuario!.toMap(usuario!)),
    );
  }

  Widget _settingsButton() {
    return IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => goto(
            context,
            AjustesPerfil(
              usuario: usuario!,
            )));
  }

  Widget _editButton() {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () async {
          bool? updated = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfile(usuario: widget.usuario!)),
          );
          if (updated == true) {
            _update();
          }
        });
  }

  Widget _getHeader() {
    final scaffColor = Theme.of(context).scaffoldBackgroundColor;
    return Container(
      color: Palette.mainGreen,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            UserAvatar(
                foto: usuario?.foto ?? "regular.png", width: 112, height: 112),
            SizedBox(height: 16),
            Text(
              usuario!.nombreCompleto(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: scaffColor),
            ),
            SizedBox(height: 4),
            Text(
              usuario!.carreras!.join("/ "),
              textAlign: TextAlign.center,
              style: TextStyle(color: scaffColor),
            ),
            SizedBox(height: 8),
            Text(
              "${usuario!.semestre} semestre",
              style: TextStyle(fontWeight: FontWeight.w500, color: scaffColor),
            ),
            usuario?.bio != null && usuario?.bio?.trim() != ""
                ? Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                    child: Text(usuario?.bio ?? "",
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(color: scaffColor)),
                  )
                : Container(),
            _socialMediaButtons(),
            SizedBox(height: 24)
          ],
        ),
      ),
    );
  }

  Widget _socialMediaButtons() {
    final _socialMediaButton = (urlString, icon) => IconButton(
        color: Theme.of(context).scaffoldBackgroundColor,
        onPressed: () => launchURL(urlString),
        icon: icon);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            runSpacing: 8,
            children: [
              usuario!.tel != null && usuario!.tel != ""
                  ? _socialMediaButton("https://wa.me/${usuario!.tel}",
                      FaIcon(FontAwesomeIcons.whatsapp))
                  : Container(),
              usuario!.correo != null && usuario!.correo != ""
                  ? _socialMediaButton("mailto:${usuario!.correo}",
                      FaIcon(FontAwesomeIcons.envelope))
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
      {required String title, bool verTodos = true, Function? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headline6),
          verTodos
              ? InkWell(
                  child: Text("Ver todos"),
                  onTap: () {
                    print('tapped');
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Widget categoryListViewFromMap(
      {required BuildContext context,
      required String sectionTitle,
      bool verTodos = true,
      Function? onVerTodos,
      required List<Map<String, dynamic>> list,
      required Function cardFunction,
      double cardWidth = 150,
      double cardHeight = 150}) {
    return list.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              _sectionTitle(title: sectionTitle, verTodos: false),
              SizedBox(height: 8),
              Container(
                height: cardHeight,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      accentColor: Theme.of(context).scaffoldBackgroundColor),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length + 2,
                    itemBuilder: (context, index) {
                      return index == 0 || index == list.length + 1
                          ? Container(width: 16)
                          : cardFunction(
                              list[index - 1], cardWidth, cardHeight, context);
                    },
                  ),
                ),
              )
            ],
          )
        : Container();
  }

  Widget categoryListView(
      {required BuildContext context,
      required String sectionTitle,
      bool verTodos = true,
      Function? onVerTodos,
      required List<Object> list,
      required Function cardFunction,
      double cardWidth = 150,
      double cardHeight = 150}) {
    return list.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              _sectionTitle(title: sectionTitle, verTodos: false),
              SizedBox(height: 8),
              Container(
                height: cardHeight,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      accentColor: Theme.of(context).scaffoldBackgroundColor),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length + 2,
                    itemBuilder: (context, index) {
                      return index == 0 || index == list.length + 1
                          ? Container(width: 16)
                          : cardFunction(
                              list[index - 1], cardWidth, cardHeight, context);
                    },
                  ),
                ),
              )
            ],
          )
        : Container();
  }
}
