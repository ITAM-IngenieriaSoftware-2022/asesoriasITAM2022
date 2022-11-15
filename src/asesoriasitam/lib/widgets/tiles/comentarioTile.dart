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
      subtitle: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(comentario.texto ?? "-",
                  style: TextStyle(color: Colors.black)),
            ),
            Text(comentario.recomiendo! ? "Recomiendo" : "No recomiendo")
          ],
        ),
      ),
    ),
  );
}
