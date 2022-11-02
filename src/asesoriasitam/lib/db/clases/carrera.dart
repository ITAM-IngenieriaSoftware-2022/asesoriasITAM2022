class Carrera {
  late String uid, nombre;
  late int color;
  Carrera({required this.uid, required this.nombre, required this.color});
  Carrera.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.nombre = mapData["nombre"];
    this.color = mapData["color"];
  }
  Map toMap(Carrera carrera) {
    var data = Map<String, dynamic>();
    data["uid"] = carrera.uid;
    data["nombre"] = carrera.nombre;
    data["color"] = carrera.color;
    return data;
  }
}
