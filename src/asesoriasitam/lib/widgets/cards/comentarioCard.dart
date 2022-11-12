import 'package:asesoriasitam/db/clases/comentario.dart';
import 'package:asesoriasitam/palette.dart';
import 'package:asesoriasitam/utils/usefulWidgets.dart';
import 'package:asesoriasitam/widgets/userAvatar.dart';
import 'package:flutter/material.dart';

Widget comentarioCard(Comentario comentario, double height, double width) {
  return CenteredConstrainedBox(
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Palette.ultraLight,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              UserAvatar(
                  foto: comentario.usuarioFoto ?? "regular.png",
                  width: 25,
                  height: 25),
              Text(comentario.nombreCompletoUsuario ?? "Sepa")
            ],
          )
        ]),
      ),
    ),
  );
}
