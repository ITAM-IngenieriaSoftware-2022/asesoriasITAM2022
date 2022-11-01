import 'package:asesoriasitam/palette.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  ///Must live in imagenes/perfil/
  final String foto;
  final double width;
  final double height;
  const UserAvatar(
      {Key? key, required this.foto, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: CircleAvatar(
        backgroundImage: AssetImage("imagenes/perfil/" + foto),
        backgroundColor: Palette.lightGreen,
      ),
    );
  }
}
