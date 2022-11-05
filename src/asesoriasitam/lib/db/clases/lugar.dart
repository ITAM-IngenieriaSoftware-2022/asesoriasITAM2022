class Lugar {
  late String uid, nombre;
  late int color;
  Lugar({required this.uid, required this.nombre, required this.color});

  Lugar.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.nombre = mapData["nombre"];
    this.color = mapData["color"];
  }
  Map<String, dynamic> toMap(Lugar Lugar) {
    var data = Map<String, dynamic>();
    data["uid"] = Lugar.uid;
    data["nombre"] = Lugar.nombre;
    data["color"] = Lugar.color;
    return data;
  }
}
