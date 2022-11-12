import 'package:asesoriasitam/db/clases/interface_card_tile.dart';
import 'package:asesoriasitam/widgets/cards/comentarioCard.dart';
import 'package:asesoriasitam/widgets/tiles/comentarioTile.dart';
import 'package:flutter/material.dart';

class Comentario implements IncluyeCardTile {
  late String? uid,
      nombreCompletoUsuario,
      porUsuario,
      texto,
      usuarioFoto,
      asesoriaUid;
  late bool? recomiendo;
  late DateTime? subido;
  Comentario(
      {this.uid,
      this.nombreCompletoUsuario,
      this.porUsuario,
      this.texto,
      this.usuarioFoto,
      this.recomiendo,
      this.subido});

  Comentario.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData["uid"];
    this.nombreCompletoUsuario = mapData["nombreCompletoUsuario"];
    this.porUsuario = mapData["porUsuario"];
    this.texto = mapData["texto"];
    this.usuarioFoto = mapData["usuarioFoto"];
    this.asesoriaUid = mapData["asesoriaUid"];
    this.recomiendo = mapData["recomiendo"];
    this.subido = DateTime.parse(mapData["subido"].toDate().toString());
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
    data["subido"] = obj.subido;
    return data;
  }

  @override
  Widget card({required BuildContext context}) {
    return comentarioCard(this, 200, 200);
  }

  @override
  IncluyeCardTile fromMap(Map<String, dynamic> mapData) {
    return Comentario.fromMap(mapData);
  }

  @override
  Widget tile({required BuildContext context}) {
    return comentarioTile(context: context, comentario: this);
  }

  @override
  Widget incompleteTile({required BuildContext context}) {
    throw UnimplementedError();
  }
}
