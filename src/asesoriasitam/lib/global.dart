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

  static Map<String, int> coloresDepto = {
    'ACTUARIA Y SEGUROS': 4293943954,
    'ADMINISTRACION': 4293874512,
    'CIENCIA POLITICA': 4294930499,
    'COMPUTACION': 4281944491,
    'CONTABILIDAD': 4288584996,
    'CTRO DE ESTUDIO DEL BIENESTAR': 4281236786,
    'DERECHO': 4278426597,
    'ECONOMIA': 4294938368,
    'ESTADISTICA': 4289415100,
    'ESTUDIOS GENERALES': 4294918273,
    'ESTUDIOS INTERNACIONALES': 4280723098, //
    'ING. INDUSTRIAL Y OPERACIONES': 4281944491,
    'LENGUAS (CLE)': 4280723098,
    'LENGUAS (LEN)': 4280723098,
    'MATEMATICAS': 4284301367,
    'SISTEMAS DIGITALES': 4281944491
  };

  static Future<void> getUsuario({required String uid}) async {
    print("getting user fromBd in global...");
    print(FirebaseAuth.instance.currentUser?.emailVerified);
    usuario = await UsuarioBloc().getUserFromDB(uid: uid);
  }

  static void clear() {
    usuario = null;
  }
}
