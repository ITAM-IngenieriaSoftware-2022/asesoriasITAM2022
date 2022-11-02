import 'package:firebase_auth/firebase_auth.dart';

import 'db/clases/usuario.dart';
import 'db/usuario_bloc.dart';

class Global {
  static Usuario? usuario;
  static bool registering = false;
  //Legal
  static String terminosURL = "";
  static String privacidadURL = "";

  static Future<void> getUsuario({required String uid}) async {
    print("getting user fromBd in global...");
    print(FirebaseAuth.instance.currentUser?.emailVerified);
    usuario = await UsuarioBloc().getUserFromDB(uid: uid);
  }

  static void clear() {
    usuario = null;
  }
}
