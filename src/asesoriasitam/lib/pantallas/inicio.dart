import 'package:asesoriasitam/db/auth_services.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/db/inicio_bloc.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/pantallas/asesorias/anuncia_asesoria.dart';
import 'package:asesoriasitam/pantallas/clases_de_depto.dart';
import 'package:asesoriasitam/pantallas/perfil/perfil.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/utils/usefulWidgets.dart';
import 'package:asesoriasitam/widgets/cards/aviso.dart';
import 'package:asesoriasitam/widgets/cards/cards.dart';

import 'package:asesoriasitam/widgets/userAvatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Usuario? usuario;

  //UI controllers
  bool _loading = true;

  //Aviso
  AvisoCard? _avisoCard;

  // Listas
  List<Asesoria> mejoresAsesorias = [];

  @override
  void initState() {
    super.initState();
    print("in inicio...");
    getData();
  }

  //can call descubre utils directly
  getData() async {
    await getCurrentUser();
    getAviso();
    getMejoresAsesorias();
    setState(() {
      _loading = false;
    });
  }

  getCurrentUser() async {
    try {
      //Usuario usr =await UsuarioBloc().getUserFromDB(uid: auth.currentUser.uid);
      //print(context.read<User>().uid);
      await Global.getUsuario(uid: context.read<User?>()!.uid);
      //print('set user in global: ${Global.usuario.nombreCompleto()}');
      setState(() {
        usuario = Global.usuario!;
      });
    } catch (e) {
      print(e);
      context.read<AuthenticationService>().signOut();
    }
  }

  getMejoresAsesorias() async {
    try {
      List<Asesoria> temp = await InicioUtils().getMejoresAsesorias(20);
      setState(() {
        mejoresAsesorias = temp;
        print(mejoresAsesorias);
      });
    } catch (e) {
      print('error getting mejores asesorias');
      print(e);
    }
  }

  getAviso() async {
    try {
      AvisoCard _temp = await InicioUtils().getAvisoCard();
      setState(() {
        _avisoCard = _temp;
      });
    } catch (e) {
      print(e);
    }
  }

  getListViewData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asesorias ITAM"),
        centerTitle: true,
      ),
      body: CenteredConstrainedBox(maxWidth: 750, child: _mainColumn(context)),
      drawer: Drawer(child: usuario == null ? Container() : _showDrawer()),
    );
  }

  Widget _loadingScreen() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          )
        ]);
  }

  Widget _mainColumn(BuildContext context) {
    return _loading
        ? _loadingScreen()
        : ListView(
            children: [
              SizedBox(height: 32),
              //Hola
              _categoryTitle("Hola ${usuario?.nombre},"),
              //Message Card
              _avisoCard != null
                  ? CenteredConstrainedBox(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: _avisoCard),
                    )
                  : Container(),
              // Busca por departamento
              _categoryTitle("Encuentra asesorias por clase"),
              Center(child: deptoChipWrap()),

              // Mejores asesorias
              _categoryTitle("Asesorias más recomendadas"),
              Center(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: mejoresAsesorias
                      .map((e) => asesoriaCard(e, 250, 150, context))
                      .toList(),
                ),
              ),
              SizedBox(
                height: 48,
              )
            ],
          );
  }

  Widget _showDrawer() {
    final txtStyle = Theme.of(context).textTheme.headline6!;
    var u = usuario;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 32, bottom: 16.0, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAvatar(
                    foto: usuario?.foto ?? "regular.png",
                    width: 68,
                    height: 68),
                SizedBox(height: 8),
                Text(usuario!.nombreCompleto(), maxLines: 1, style: txtStyle),
                Text(
                  usuario?.correo ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).hintColor),
                ),
                SizedBox(height: 4),
                Text(
                  "${usuario!.semestre} semestre",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Divider(),
          _drawerTile(
              "Mi Perfil", CupertinoIcons.person, Perfil(usuario: usuario)),
          _drawerTile(
              "Anunciar asesoria",
              CupertinoIcons.dot_radiowaves_left_right,
              AnunciaAsesoria(usuario: usuario!)),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                title: Text("Cerrar Sesión",
                    style: Theme.of(context).textTheme.headline6!),
                minLeadingWidth: 0,
                onTap: () {
                  context.read<AuthenticationService>().signOut();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(String title, IconData tileIcon, Widget pageToPush) {
    return ListTile(
      title: Text(title,
          style: Theme.of(context).textTheme.headline6!.copyWith(
              //fontSize: 18,
              //fontWeight: FontWeight.w400,
              )),
      minLeadingWidth: 0,
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => pageToPush));
      },
    );
  }

  Widget _categoryTitle(String s) {
    return Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 24, bottom: 16),
        child: Text(s,
            style: Theme.of(context)
                .textTheme
                .headline6) //TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        );
  }

  Widget deptoChipWrap() {
    print(Colors.green);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: Global.departamentos
            .map((depto) => _buildChip(depto)) //Color(e.color).withOpacity(1)))
            .toList(),
      ),
    );
  }

  Widget _buildChip(String depto) {
    //, Color color) {
    return ActionChip(
      key: Key(depto),
      labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      label: Text(
        depto,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(Global.coloresDepto[
          depto]!), // Palette.mainGreen, //color.withOpacity(0.8),
      onPressed: () {
        print("Se selecciono el depto $depto");
        goto(context, ClasesDepto(depto: depto));
      },
    );
  }
}
