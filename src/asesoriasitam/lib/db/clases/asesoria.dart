class Asesoria {
  late String? uid,
      nombreCompletoUsuario,
      porUsuario,
      descripcionCorta,
      detalles,
      usuarioFoto;
  late String? mail, tel, wa, imagenUrl;
  late bool? visible;
  late List<String>? clasesUid;
  late List<String>? clasesNombres;
  late List<String>? recomendadoPor;
  late int? recomendadoPorN;
  Asesoria(
      {this.uid,
      this.nombreCompletoUsuario,
      this.porUsuario,
      this.usuarioFoto,
      this.mail,
      this.tel,
      this.wa,
      this.descripcionCorta,
      this.detalles,
      this.recomendadoPor,
      this.recomendadoPorN,
      this.clasesUid,
      this.visible,
      this.imagenUrl});
  Asesoria.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.nombreCompletoUsuario = mapData["nombreCompletoUsuario"];
    this.porUsuario = mapData["porUsuario"];
    this.usuarioFoto = mapData["usuarioFoto"];
    this.mail = mapData["mail"];
    this.wa = mapData["wa"];
    this.tel = mapData["tel"];
    this.descripcionCorta = mapData["descripcionCorta"];
    this.detalles = mapData["detalles"];
    this.imagenUrl = mapData["imagenUrl"];
    this.recomendadoPorN = mapData["recomendadoPorN"];
    this.recomendadoPor = List.from(mapData["recomendadoPor"]);
    this.clasesUid = List.from(mapData["clasesUid"]);
    this.clasesNombres = List.from(mapData["clasesNombres"]);
    this.visible = mapData["visible"];
  }
  Map<String, dynamic> toMap(Asesoria grupo) {
    var data = Map<String, dynamic>();
    data["uid"] = grupo.uid;
    data["nombreCompletoUsuario"] = grupo.nombreCompletoUsuario;
    data["porUsuario"] = grupo.porUsuario;
    data["usuarioFoto"] = grupo.usuarioFoto;
    data["mail"] = grupo.mail;
    data["wa"] = grupo.wa;
    data["tel"] = grupo.tel;
    data["descripcionCorta"] = grupo.descripcionCorta;
    data["detalles"] = grupo.detalles;
    data["recomendadoPor"] = grupo.recomendadoPor;
    data["recomendadoPorN"] = grupo.recomendadoPorN;
    data["clasesUid"] = grupo.clasesUid;
    data["clasesNombres"] = grupo.clasesNombres;
    data["imagenUrl"] = grupo.imagenUrl;
    data["visible"] = visible;
    return data;
  }
}
