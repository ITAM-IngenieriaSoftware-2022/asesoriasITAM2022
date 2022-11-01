import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'clases/usuario.dart';

class UsuarioBloc {
  final userRef = FirebaseFirestore.instance.collection("usuarios");
  final grupoRef = FirebaseFirestore.instance.collection("grupos");
  final claseRef = FirebaseFirestore.instance.collection("clases");
  final profRef = FirebaseFirestore.instance.collection("profesores");
  final asesoriaRef = FirebaseFirestore.instance.collection("asesorias");
  final archivosRef = FirebaseFirestore.instance.collection("archivos");

  Future<void> addUserToDB({required Usuario usuario}) async {
    print(FirebaseAuth.instance.currentUser?.uid);
    print(FirebaseAuth.instance.currentUser?.emailVerified);
    await userRef.doc(usuario.uid).update({
      "fechaRegistro": usuario.fechaRegistro,
      "foto": usuario.foto,
      "carreras": usuario.carreras,
      "nombre": usuario.nombre,
      "apellido": usuario.apellido,
      "semestre": usuario.semestre
    });
  }

  Future<Usuario> getUserFromDB({required String uid}) async {
    print(uid);
    final DocumentSnapshot doc = await userRef.doc(uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Usuario.fromMap(data);
  }

  Future<List<Usuario>> getUsers({required List<String> usuarios}) async {
    List<Usuario> out = [];
    try {
      QuerySnapshot response =
          await userRef.where('uid', whereIn: usuarios).get();
      if (response.docs.isNotEmpty) {
        for (QueryDocumentSnapshot d in response.docs) {
          Map<String, dynamic> data = d.data() as Map<String, dynamic>;
          out.add(Usuario.fromMap(data));
        }
      }
      return out;
    } catch (e) {
      print(e);
      return out;
    }
  }

  ///Transaction. Updates usuario after edit usuario.
  Future<void> updateUsuario({required Usuario usuario}) async {
    DocumentReference usuarioDoc = userRef.doc(usuario.uid);
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(usuarioDoc);
      if (!snapshot.exists) {
        throw Exception("Usuario no existe");
      }
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      transaction.update(
        usuarioDoc,
        {
          "nombre": usuario.nombre,
          "apellido": usuario.apellido,
          "bio": usuario.bio,
          "instagram": usuario.instagram,
          "twitter": usuario.twitter,
          "facebook": usuario.facebook,
          "semestre": usuario.semestre,
          "carreras": usuario.carreras,
          "foto": usuario.foto,
          "clases": data["clases"], //cound change while updating
          "grupos": data["grupos"],
        },
      );
    });
  }
}
