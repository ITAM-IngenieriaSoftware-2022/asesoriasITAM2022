class Carrera {
  late String uid, nombre;
  late int color;
  late List<String>? materias;
  Carrera(
      {required this.uid,
      required this.nombre,
      required this.color,
      required this.materias});
  Carrera.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.nombre = mapData["nombre"];
    this.color = mapData["color"];
    this.materias =
        mapData["materias"] != null ? List.from(mapData["materias"]) : null;
  }
  Map toMap(Carrera carrera) {
    var data = Map<String, dynamic>();
    data["uid"] = carrera.uid;
    data["nombre"] = carrera.nombre;
    data["color"] = carrera.color;
    data["materias"] = carrera.color;
    return data;
  }
}
