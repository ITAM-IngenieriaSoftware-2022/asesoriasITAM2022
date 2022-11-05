import 'package:cloud_firestore/cloud_firestore.dart';

import 'clases/clase.dart';

class ClaseBloc {
  final claseRef = FirebaseFirestore.instance.collection("clases");

  Future<Clase> getClaseFromDB({required String uid}) async {
    final DocumentSnapshot doc = await claseRef.doc(uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Clase.fromMap(data);
  }

  Future<List<Clase>> getClasesByDepto({required String depto}) async {
    List<Clase> out = [];
    try {
      final QuerySnapshot doc =
          await claseRef.where('depto', isEqualTo: depto).get();

      for (QueryDocumentSnapshot d in doc.docs) {
        Map<String, dynamic> data = d.data() as Map<String, dynamic>;
        data['uid'] = d.id;
        out.add(Clase.fromMap(data));
      }
      return out;
    } catch (e) {
      throw e;
    }
  }
}
