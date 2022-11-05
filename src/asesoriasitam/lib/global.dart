import 'package:firebase_auth/firebase_auth.dart';

import 'db/clases/usuario.dart';
import 'db/usuario_bloc.dart';

class Global {
  static Usuario? usuario;
  static bool registering = false;
  // Legal
  static String terminosURL = "";
  static String privacidadURL = "";
  // Deptos
  static List<String> departamentos = [
    'ACTUARIA Y SEGUROS',
    'ADMINISTRACION',
    'CIENCIA POLITICA',
    'COMPUTACION',
    'CONTABILIDAD',
    'CTRO DE ESTUDIO DEL BIENESTAR',
    'DERECHO',
    'ECONOMIA',
    'ESTADISTICA',
    'ESTUDIOS GENERALES',
    'ESTUDIOS INTERNACIONALES',
    'ING. INDUSTRIAL Y OPERACIONES',
    'LENGUAS (CLE)',
    'LENGUAS (LEN)',
    'MATEMATICAS',
    'SISTEMAS DIGITALES'
  ];

  static Future<void> getUsuario({required String uid}) async {
    print("getting user fromBd in global...");
    print(FirebaseAuth.instance.currentUser?.emailVerified);
    usuario = await UsuarioBloc().getUserFromDB(uid: uid);
  }

  static void clear() {
    usuario = null;
  }
}
