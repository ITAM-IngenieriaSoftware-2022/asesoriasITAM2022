import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/db/clases/comentario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AsesoriaBloc {
  final userRef = FirebaseFirestore.instance.collection("usuarios");
  final asesoriasRef = FirebaseFirestore.instance.collection("asesorias");
  final claseRef = FirebaseFirestore.instance.collection("clases");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> subirAsesoria({required Asesoria asesoria}) async {
    //await asesoriasRef.doc(asesoria.uid).set(asesoria.toMap(asesoria));
    DocumentReference asesoriaDoc = asesoriasRef.doc(asesoria.uid);
    DocumentReference claseDoc = claseRef.doc(asesoria.clase);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Subimos la asesoria
      transaction.set(asesoriaDoc, asesoria.toMap(asesoria));

      // Actualizamos clasesUid de la clase correspondiente
      transaction.update(claseDoc, {
        'asesoriasUids': FieldValue.arrayUnion([asesoria.uid])
      });
    });
  }

  Future<Asesoria> getAsesoria({required String uid}) async {
    DocumentSnapshot doc = await asesoriasRef.doc(uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Asesoria.fromMap(data);
  }

  Future<void> borrarAsesoria({required Asesoria asesoria}) async {
    //await asesoriasRef.doc(asesoria.uid).delete();
    DocumentReference asesoriaDoc = asesoriasRef.doc(asesoria.uid);
    DocumentReference claseDoc = claseRef.doc(asesoria.clase);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Borramos la asesoria
      transaction.delete(asesoriaDoc);

      // Actualizamos clasesUid de la clase correspondiente
      transaction.update(claseDoc, {
        'asesoriasUids': FieldValue.arrayRemove([asesoria.uid])
      });
    });
  }

  Future<void> updateAsesoria({required Asesoria asesoria}) async {
    DocumentReference asesoriaDoc = asesoriasRef.doc(asesoria.uid);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(asesoriaDoc);
      if (!snapshot.exists) {
        throw Exception("Asesoria no existe");
      }
      transaction.update(
        asesoriaDoc,
        {
          "detalles": asesoria.detalles,
          "mail": asesoria.mail,
          "wa": asesoria.wa,
          "tel": asesoria.tel,
          "visible": asesoria.visible,
          "lugares": asesoria.lugares,
          "precio": asesoria.precio,
          "horario": asesoria.horario,
        },
      );
    });
  }

  Future<void> calificarAsesoria(
      {required Asesoria asesoria, required Comentario comentario}) {
    DocumentReference asesoriaDoc = asesoriasRef.doc(asesoria.uid);
    DocumentReference comentarioDoc = asesoriasRef
        .doc(comentario.asesoriaUid)
        .collection('comentarios')
        .doc(comentario.uid);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Aumentamos/disminuimos los recomendados por N.
      transaction.update(asesoriaDoc, {
        'recomendadoPorN': FieldValue.increment(comentario.recomiendo! ? 1 : -1)
      });
      // Subimos el comentario
      transaction.set(comentarioDoc, comentario.toMap(comentario));
    });
  }

  Future<void> actualizarCalificacion(
      {required Asesoria asesoria,
      required Comentario comentario,
      required bool recomiendoOld}) {
    DocumentReference asesoriaDoc = asesoriasRef.doc(asesoria.uid);
    DocumentReference comentarioDoc = asesoriasRef
        .doc(comentario.asesoriaUid)
        .collection('comentarios')
        .doc(comentario.uid);

    int incBy = 0;
    if (recomiendoOld == comentario.recomiendo) {
      incBy = 0;
    } else if (!recomiendoOld && comentario.recomiendo!) {
      // Si antes no recomendaba (-1) y ahora si (+1) tenemos que sumar +2
      incBy = 2;
    } else {
      // Si antes recomendaba (+1) y ahora no (-1) tenemos que sumar -2
      incBy = -2;
    }

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Aumentamos/disminuimos los recomendados por N.
      transaction.update(
          asesoriaDoc, {'recomendadoPorN': FieldValue.increment(incBy)});
      // Subimos el comentario
      transaction.update(comentarioDoc, comentario.toMap(comentario));
    });
  }

  Future<void> descalificarAsesoria(
      {required Asesoria asesoria, required Comentario comentario}) {
    DocumentReference asesoriaDoc = asesoriasRef.doc(asesoria.uid);
    DocumentReference comentarioDoc = asesoriasRef
        .doc(comentario.asesoriaUid)
        .collection('comentarios')
        .doc(comentario.uid);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Aumentamos/disminuimos los recomendados por N.
      transaction.update(asesoriaDoc, {
        'recomendadoPorN': FieldValue.increment(comentario.recomiendo! ? -1 : 1)
      });
      // Borramos el comentario
      transaction.delete(comentarioDoc);
    });
  }

  Future<List<Asesoria>> getAsesoriasByUsuario(
      {required String usuarioUid, bool onlyVisible = true}) async {
    List<Asesoria> out = [];
    QuerySnapshot doc;
    try {
      if (onlyVisible) {
        doc = await asesoriasRef
            .where('porUsuario', isEqualTo: usuarioUid)
            .where('visible', isEqualTo: true)
            .where('baneado', isEqualTo: false)
            .get();
      } else {
        doc =
            await asesoriasRef.where('porUsuario', isEqualTo: usuarioUid).get();
      }

      for (QueryDocumentSnapshot d in doc.docs) {
        Map<String, dynamic> data = d.data() as Map<String, dynamic>;
        out.add(Asesoria.fromMap(data));
      }
      return out;
    } catch (e) {
      throw e;
    }
  }

  // Ordenadas por recomendadasPorN por defecto
  Future<List<Asesoria>> getAsesoriasByClase({required String claseUid}) async {
    List<Asesoria> out = [];
    try {
      final QuerySnapshot doc = await asesoriasRef
          .where('clase', isEqualTo: claseUid)
          .where('visible', isEqualTo: true)
          .where('baneado', isEqualTo: false)
          .orderBy('recomendadoPorN', descending: true)
          .get();

      for (QueryDocumentSnapshot d in doc.docs) {
        Map<String, dynamic> data = d.data() as Map<String, dynamic>;
        out.add(Asesoria.fromMap(data));
      }
      return out;
    } catch (e) {
      throw e;
    }
  }
}
