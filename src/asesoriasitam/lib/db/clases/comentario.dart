class Comentario {
  late String? uid,
      nombreCompletoUsuario,
      porUsuario,
      texto,
      usuarioFoto,
      asesoriaUid;
  late bool? recomiendo;
  Comentario(
      {this.uid,
      this.nombreCompletoUsuario,
      this.porUsuario,
      this.texto,
      this.usuarioFoto,
      this.recomiendo});

  Comentario.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.nombreCompletoUsuario = mapData["nombreCompletoUsuario"];
    this.porUsuario = mapData["porUsuario"];
    this.texto = mapData["texto"];
    this.usuarioFoto = mapData["usuarioFoto"];
    this.asesoriaUid = mapData["asesoriaUid"];
    this.recomiendo = mapData["recomiendo"];
  }
  Map<String, dynamic> toMap(Comentario obj) {
    var data = Map<String, dynamic>();
    data["uid"] = obj.uid;
    data["nombreCompletoUsuario"] = obj.nombreCompletoUsuario;
    data["porUsuario"] = obj.porUsuario;
    data["texto"] = obj.texto;
    data["usuarioFoto"] = obj.usuarioFoto;
    data["asesoriaUid"] = obj.asesoriaUid;
    data["recomiendo"] = obj.recomiendo;
    return data;
  }
}
