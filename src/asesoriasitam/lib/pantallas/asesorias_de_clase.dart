import 'package:asesoriasitam/db/asesoria_bloc.dart';
import 'package:asesoriasitam/db/auth_services.dart';
import 'package:asesoriasitam/db/clase_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/clase.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/db/inicio_bloc.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/usefulWidgets.dart';
import 'package:asesoriasitam/widgets/cards/aviso.dart';
import 'package:asesoriasitam/widgets/cards/cards.dart';
import 'package:asesoriasitam/widgets/screens/unu.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AsesoriasClase extends StatefulWidget {
  final String claseUid;

  const AsesoriasClase({Key? key, required this.claseUid}) : super(key: key);
  @override
  _AsesoriasClaseState createState() => _AsesoriasClaseState(claseUid);
}

class _AsesoriasClaseState extends State<AsesoriasClase> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Usuario? usuario;

  String claseUid;

  List<Asesoria> asesorias = [];

  // UI controllers
  bool _loading = true;
  bool gotAsesorias = false;
  bool gotClase = false;

  _AsesoriasClaseState(this.claseUid);

  @override
  void initState() {
    super.initState();
    print("in AsesoriasClase...");
    getData();
  }

  getData() async {
    await getCurrentUser();
    await _getAsesoriaDeClase();
    setState(() {
      _loading = false;
    });
  }

  Future<void> _getAsesoriaDeClase() async {
    print("Intentando conseguir asesorias de clase $claseUid...");
    asesorias = [];
    try {
      List<Asesoria> nuevos =
          await AsesoriaBloc().getAsesoriasByClase(claseUid: claseUid);
      setState(() {
        asesorias = nuevos;
        gotAsesorias = true;
        print("Got ${asesorias.length} asesorias de clase $claseUid");
      });
    } catch (e) {
      print("Error consiguiendo asesorias de clase $claseUid:");
      print(e);
    }
  }

  getCurrentUser() async {
    try {
      await Global.getUsuario(uid: context.read<User?>()!.uid);
      setState(() {
        usuario = Global.usuario!;
      });
    } catch (e) {
      print(e);
      context.read<AuthenticationService>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(color: Palette.mainGreen),
      ),
      body: CenteredConstrainedBox(maxWidth: 750, child: _mainColumn(context)),
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
    List<Widget> content = [
      SizedBox(height: 32),
      //Hola
      _categoryTitle("Asesorias de $claseUid")
    ];
    content.addAll(asesorias.map((e) => asesoriaCard(e, 250, 150, context)));
    return _loading
        ? _loadingScreen()
        : CenteredConstrainedBox(
            child: asesorias.isEmpty
                ? unuColumn(
                    context: context, texto: 'No hay asesorias para esta clase')
                : ListView(children: content));
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
}
