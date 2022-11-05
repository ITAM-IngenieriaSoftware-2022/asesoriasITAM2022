class Clase {
  late String uid, nombre, depto;
  late List<String> asesoriasUids;
  late int color;
  Clase(
      {required this.uid,
      required this.nombre,
      required this.depto,
      required this.color,
      required this.asesoriasUids});

  Clase.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.nombre = mapData["uid"];
    this.depto = mapData["depto"];
    this.color = mapData["color"];

    this.asesoriasUids = List.from(mapData["asesoriasUids"]);
  }
  Map<String, dynamic> toMap(Clase clase) {
    var data = Map<String, dynamic>();
    data["uid"] = clase.uid;
    data["nombre"] = clase.uid;
    data["depto"] = clase.depto;
    data["color"] = clase.color;
    data["asesoriasUids"] = clase.asesoriasUids;
    return data;
  }
}
