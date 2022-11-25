import 'package:asesoriasitam/db/clases/asesoria.dart';
import 'package:asesoriasitam/pantallas/asesorias/asesoria.dart';
import 'package:asesoriasitam/utils/functionality.dart';
import 'package:asesoriasitam/widgets/tappableCard.dart';
import 'package:asesoriasitam/widgets/userAvatar.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

Widget inicioCard() {
  return Stack(
    children: [
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
              width: double.infinity,
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text("sldkfjsldfkjslfkjsdlfkajsd;lfkjalsdkfja")],
              ))),
      Container(
        width: 150,
        height: 150,
        child: Image.asset("imagenes/perfil/regular.png"),
      ),
    ],
  );
}

Widget asesoriaCard(Asesoria asesoria, double cardWidth, double cardHeight,
    BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: TappableCard(
      cardWidth: cardWidth,
      cardHeight: cardHeight,
      onTap: () => goto(
          context, AsesoriaPage(asesoria: asesoria)), //asesoria: asesoria)),
      cardContent: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserAvatar(foto: asesoria.usuarioFoto!, width: 32, height: 32),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asesoria.nombreCompletoUsuario!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    Wrap(
                      children: [
                        Text(
                          asesoria.recomendadoPorN! > 0
                              ? "Recomendado por ${asesoria.recomendadoPorN}"
                              : "Sin recomendaciones",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        !asesoria.visible!
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.visibility_off,
                                  size: 12,
                                  color: Theme.of(context).hintColor,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              asesoria.detalles!,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(height: 4),
            Text('Clase: ${asesoria.clase}',
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 11, color: Colors.grey))
          ],
        ),
      ),
    ),
  );
}
