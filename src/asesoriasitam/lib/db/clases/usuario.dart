class Usuario {
  late String? uid, correo, nombre, apellido, foto;
  late String? tel, bio;
  late List<String>? carreras;

  late Map<String, dynamic>? grupos;
  late Map<String, dynamic>? clases;
  late int? chems, semestre;
  late DateTime? fechaRegistro;
  Usuario(
      {this.uid,
      this.correo,
      this.nombre,
      this.apellido,
      this.carreras,
      this.tel,
      this.bio,
      this.grupos,
      this.clases,
      this.chems,
      this.semestre,
      this.fechaRegistro,
      this.foto});

  String nombreCompleto() {
    return (this.nombre ?? "Null nombre") +
        " " +
        (this.apellido ?? "Null apellido");
  }

  Map<String, dynamic> toMap(Usuario usuario) {
    var data = Map<String, dynamic>();

    data["uid"] = usuario.uid;
    data["correo"] = usuario.correo;
    data["nombre"] = usuario.nombre;
    data["apellido"] = usuario.apellido;
    data["carreras"] = usuario.carreras;
    data["tel"] = usuario.tel;
    data["bio"] = usuario.bio;
    data["grupos"] = usuario.grupos;
    data["clases"] = usuario.clases;
    data["chems"] = usuario.chems;
    data["semestre"] = usuario.semestre;
    data["fechaRegistro"] = usuario.fechaRegistro;
    data["foto"] = usuario.foto;

    return data;
  }

  Usuario.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.correo = mapData["correo"];
    this.nombre = mapData["nombre"];
    this.apellido = mapData["apellido"];
    this.carreras =
        mapData["carreras"] != null ? List.from(mapData["carreras"]) : [];
    this.tel = mapData["tel"];
    this.bio = mapData["bio"];
    this.grupos = mapData["grupos"];
    this.clases = mapData["clases"];
    this.chems = mapData["chems"];
    this.semestre = mapData["semestre"];
    this.foto = mapData["foto"];
    if (mapData.containsKey(["fechaRegistro"]) && mapData["fechaRegistro"])
      this.fechaRegistro =
          DateTime.parse(mapData["fechaRegistro"].toDate().toString());
    else
      this.fechaRegistro = DateTime.now();
  }
  @override
  String toString() {
    return this.uid! + " " + this.nombreCompleto();
  }
}
