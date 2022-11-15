import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/widgets/cards/aviso.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asesoriasitam/db/clases/clase.dart';

import 'package:asesoriasitam/db/clases/usuario.dart';

class InicioUtils {
  //final FirebaseAuth _firebaseAuth;

  final userRef = FirebaseFirestore.instance.collection("usuarios");
  final asesoriaRef = FirebaseFirestore.instance.collection("asesorias");
  final claseRef = FirebaseFirestore.instance.collection("clases");
  final infoRef = FirebaseFirestore.instance.collection("info");
  InicioUtils();

  Future<List<Asesoria>> getMejoresAsesorias(int cuantos) async {
    List<Asesoria> out = [];
    try {
      QuerySnapshot response = await asesoriaRef
          .where('visible', isEqualTo: true)
          .where('baneado', isEqualTo: false)
          .orderBy('recomendadoPorN', descending: true)
          .limit(cuantos)
          .get();
      if (response.docs.isNotEmpty) {
        for (QueryDocumentSnapshot d in response.docs) {
          Map<String, dynamic> data = d.data() as Map<String, dynamic>;
          out.add(Asesoria.fromMap(data));
        }
      }
      return out;
    } catch (e) {
      print(e);
      return out;
    }
  }

  // TODO Agregar depto a asesoria
  Future<List<Asesoria>> getMejoresAsesoriasPorDepto(
      int cuantos, String depto) async {
    List<Asesoria> out = [];
    try {
      QuerySnapshot response = await asesoriaRef
          .where('depto', isEqualTo: depto)
          .where('visible', isEqualTo: true)
          .where('baneado', isEqualTo: false)
          .orderBy('recomendadoPorN', descending: true)
          .limit(cuantos)
          .get();
      if (response.docs.isNotEmpty) {
        for (QueryDocumentSnapshot d in response.docs) {
          Map<String, dynamic> data = d.data() as Map<String, dynamic>;
          out.add(Asesoria.fromMap(data));
        }
      }
      return out;
    } catch (e) {
      print(e);
      return out;
    }
  }

  Future<AvisoCard> getAvisoCard() async {
    DocumentSnapshot response = await infoRef.doc('avisoInicio').get();
    if (response.exists) {
      Map<String, dynamic> data = response.data() as Map<String, dynamic>;
      return AvisoCard(
        image: data["imagen"],
        title: data["title"],
        texto: data["texto"],
        signedBy: data["signedBy"],
        cardHeight: data["cardHeight"],
      );
    } else {
      throw Exception('No aviso card');
    }
  }
}
