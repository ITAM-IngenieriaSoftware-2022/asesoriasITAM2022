class Asesoria {
  late String? uid,
      nombreCompletoUsuario,
      porUsuario,
      detalles,
      usuarioFoto,
      clase;
  late String? mail, tel, wa; // imagenUrl; //tomar de usuario?
  late bool? visible, baneado;
  late List<String>? recomendadoPor, lugares; //Lugares como lista??
  late int? recomendadoPorN;
  late double? precio;
  late Map<String, dynamic>? horario;
  Asesoria(
      {this.uid,
      this.nombreCompletoUsuario,
      this.porUsuario,
      this.detalles,
      this.usuarioFoto,
      this.clase,
      this.mail,
      this.tel,
      this.wa,
      //this.imagenUrl,
      this.visible,
      this.baneado,
      this.recomendadoPor,
      this.lugares,
      this.recomendadoPorN,
      this.precio,
      this.horario});
  Asesoria.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.nombreCompletoUsuario = mapData["nombreCompletoUsuario"];
    this.porUsuario = mapData["porUsuario"];
    this.detalles = mapData["detalles"];
    this.usuarioFoto = mapData["usuarioFoto"];
    this.clase = mapData["clase"];
    this.mail = mapData["mail"];
    this.tel = mapData["tel"];
    this.wa = mapData["wa"];
    //this.imagenUrl = mapData["imagenUrl"];
    this.visible = mapData["visible"];
    this.baneado = mapData["baneado"];
    this.recomendadoPor = List.from(mapData["recomendadoPor"]);
    this.lugares = List.from(mapData["lugares"]);
    this.recomendadoPorN = mapData["recomendadoPorN"];
    this.precio = mapData["precio"];
    this.horario = mapData["horario"];
  }
  Map<String, dynamic> toMap(Asesoria obj) {
    var data = Map<String, dynamic>();
    data["uid"] = obj.uid;
    data["nombreCompletoUsuario"] = obj.nombreCompletoUsuario;
    data["porUsuario"] = obj.porUsuario;
    data["detalles"] = obj.detalles;
    data["usuarioFoto"] = obj.usuarioFoto;
    data["clase"] = obj.clase;
    data["mail"] = obj.mail;
    data["tel"] = obj.tel;
    data["wa"] = obj.wa;
    //data["imagenUrl"] = obj.imagenUrl;
    data["visible"] = obj.visible;
    data["baneado"] = obj.baneado;
    data["recomendadoPor"] = obj.recomendadoPor;
    data["lugares"] = obj.lugares;
    data["recomendadoPorN"] = obj.recomendadoPorN;
    data["precio"] = obj.precio;
    data["horario"] = obj.horario;
    return data;
  }
}
