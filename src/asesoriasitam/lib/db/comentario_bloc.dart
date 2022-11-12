import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComentarioBloc {
  final asesoriasRef = FirebaseFirestore.instance.collection("asesorias");

  Future<Comentario> getComentarioByUsuario(
      Asesoria asesoria, String usuarioUid) async {
    try {
      final QuerySnapshot doc = await asesoriasRef
          .doc(asesoria.uid)
          .collection('comentarios')
          .where('porUsuario', isEqualTo: usuarioUid)
          .get();
      if (doc.docs.isEmpty) {
        throw Exception(
            'No se encontro el comentario por $usuarioUid en asesoria ${asesoria.uid}');
      } else {
        return Comentario.fromMap(
            doc.docs.first.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw e;
    }
  }
}
