import 'package:asesoriasitam/db/clases/lugar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LugarBloc {
  final lugaresRef = FirebaseFirestore.instance.collection("lugares");

  Future<List<Lugar>> getLugares() async {
    List<Lugar> out = [];
    try {
      QuerySnapshot response = await lugaresRef.get();
      for (QueryDocumentSnapshot d in response.docs) {
        Map<String, dynamic> data = d.data() as Map<String, dynamic>;
        data['uid'] = d.id;
        out.add(Lugar.fromMap(data));
      }
    } catch (e) {
      print("error getting Lugars");
      print(e);
    }
    return out;
  }
}
