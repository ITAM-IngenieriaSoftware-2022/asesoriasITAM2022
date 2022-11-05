import 'dart:io';

import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'clases/usuario.dart';

class AsesoriaBloc {
  final userRef = FirebaseFirestore.instance.collection("usuarios");
  final asesoriasRef = FirebaseFirestore.instance.collection("asesorias");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> subirAsesoria({required Asesoria asesoria}) async {
    await asesoriasRef.doc(asesoria.uid).set(asesoria.toMap(asesoria));
  }

  Future<Asesoria> getAsesoria({required String uid}) async {
    DocumentSnapshot doc = await asesoriasRef.doc(uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Asesoria.fromMap(data);
  }

  Future<void> borrarAsesoria({required Asesoria asesoria}) async {
    await asesoriasRef.doc(asesoria.uid).delete();
  }

  //transaction //TODO esto
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
          //"imagenUrl": asesoria.imagenUrl,
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

  ///Adds usuario uid to recomendadoPor and increases recomendadoPorN counter.
  Future<void> recomendarAsesoria(
      {required Asesoria asesoria, required Usuario usuario}) async {
    DocumentReference asesoriaDoc = asesoriasRef.doc(asesoria.uid);
    await asesoriaDoc.update({
      'recomendadoPorN': FieldValue.increment(1),
      'recomendadoPor': FieldValue.arrayUnion([usuario.uid])
    });
  }

  ///Removes usuario uid to recomendadoPor and decreases recomendadoPorN counter.
  Future<void> desrecomendarAsesoria(
      {required Asesoria asesoria, required Usuario usuario}) async {
    DocumentReference asesoriaDoc = asesoriasRef.doc(asesoria.uid);
    await asesoriaDoc.update({
      'recomendadoPorN': FieldValue.increment(-1),
      'recomendadoPor': FieldValue.arrayRemove([usuario.uid])
    });
  }

  Future<List<Asesoria>> getAsesoriasByUsuario(
      {required String usuarioUid}) async {
    List<Asesoria> out = [];
    try {
      final QuerySnapshot doc =
          await asesoriasRef.where('porUsuario', isEqualTo: usuarioUid).get();

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
