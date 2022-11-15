import 'package:asesoriasitam/db/auth_services.dart';
import 'package:asesoriasitam/db/clase_bloc.dart';
import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/clase.dart';
import 'package:asesoriasitam/db/clases/usuario.dart';
import 'package:asesoriasitam/db/inicio_bloc.dart';
import 'package:asesoriasitam/global.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/pantallas/asesorias_de_clase.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/utils/usefulWidgets.dart';
import 'package:asesoriasitam/widgets/cards/aviso.dart';
import 'package:asesoriasitam/widgets/screens/unu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClasesDepto extends StatefulWidget {
  final String depto;

  const ClasesDepto({Key? key, required this.depto}) : super(key: key);
  @override
  _ClasesDeptoState createState() => _ClasesDeptoState(depto);
}

class _ClasesDeptoState extends State<ClasesDepto> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Usuario? usuario;
  String depto;

  List<Clase> clasesDeDepto = [];

  //UI controllers
  bool _loading = true;
  bool gotClasesDeDepto = false;

  //Aviso
  AvisoCard? _avisoCard;

  // Listas
  List<Asesoria> mejoresAsesorias = [];

  _ClasesDeptoState(this.depto);

  @override
  void initState() {
    super.initState();
    print("in ClasesDepto...");
    getData();
  }

  //can call descubre utils directly
  getData() async {
    await getCurrentUser();
    await _getClasesDeDepto();
    setState(() {
      _loading = false;
    });
  }

  Future<void> _getClasesDeDepto() async {
    print("Intentando conseguir clases de $depto...");
    clasesDeDepto = [];
    try {
      List<Clase> nuevos = await ClaseBloc().getClasesByDepto(depto: depto);
      setState(() {
        clasesDeDepto = nuevos;
        gotClasesDeDepto = true;
        print("Got ${clasesDeDepto.length} clases de ${depto}");
      });
    } catch (e) {
      print("Error consiguiendo clases de $depto:");
      print(e);
    }
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
      _categoryTitle("Clases de $depto")
    ];
    content.addAll(clasesDeDepto.map((e) => ListTile(
          title: Text(e.nombre),
          subtitle: Text("${e.asesoriasUids.length} asesoria(s)"),
          onTap: () => goto(context, AsesoriasClase(claseUid: e.uid)),
        )));
    return _loading
        ? _loadingScreen()
        : CenteredConstrainedBox(
            child: clasesDeDepto.isEmpty
                ? unuColumn(
                    context: context,
                    texto: 'No se encontraron clases para este departamento')
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
