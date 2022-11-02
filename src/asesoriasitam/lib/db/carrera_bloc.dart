import 'package:cloud_firestore/cloud_firestore.dart';

import 'clases/carrera.dart';

class CarreraBloc {
  final carrerasRef = FirebaseFirestore.instance.collection("carreras");
  final grupoRef = FirebaseFirestore.instance.collection("grupos");

  Future<List<Carrera>> getCarreras() async {
    List<Carrera> out = [];
    try {
      QuerySnapshot response = await carrerasRef.get();
      print(response.docs.length);
      print(response.docs.first);
      for (QueryDocumentSnapshot d in response.docs) {
        Map<String, dynamic> data = d.data() as Map<String, dynamic>;
        data['uid'] = d.id;
        out.add(Carrera.fromMap(data));
      }
    } catch (e) {
      print("error getting carreras");
      print(e);
    }
    return out;
  }
}
