import 'package:asesoriasitam/db/clases/comentario.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/utils/usefulWidgets.dart';
import 'package:asesoriasitam/widgets/userAvatar.dart';
import 'package:flutter/material.dart';

Widget comentarioTile(
    {required Comentario comentario, required BuildContext context}) {
  return CenteredConstrainedBox(
    child: ListTile(
      leading: UserAvatar(
        foto: comentario.usuarioFoto ?? "regular.png",
        height: 35,
        width: 35,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(comentario.nombreCompletoUsuario ?? "Anonimo"),
          Text(dayMonthYear(comentario.subido!))
        ],
      ),
      subtitle: Text(comentario.texto ?? "-"),
    ),
  );
}
