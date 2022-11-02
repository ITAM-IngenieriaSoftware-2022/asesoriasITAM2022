import 'package:asesoriasitam/db/auth_services.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/pantallas/perfil/perfil.dart';
import 'package:asesoriasitam/utils/functionality.dart';

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
  @override
  void initState() {
    super.initState();
    print("in inicio...");
    getData();
  }

  //can call descubre utils directly
  getData() async {
    await getCurrentUser();
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

  getListViewData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asesorias ITAM"),
        centerTitle: true,
      ),
      body: _mainColumn(context),
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
              Text("Hola ${usuario?.nombre},"),
              SizedBox(height: 36),
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
                  "${shortenNumber(usuario!.chems!)} chems  ${usuario!.semestre} semestre",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Divider(),
          _drawerTile(
              "Mi Perfil", CupertinoIcons.person, Perfil(usuario: usuario)),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                title: Text("Cerrar Sesion",
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
}
