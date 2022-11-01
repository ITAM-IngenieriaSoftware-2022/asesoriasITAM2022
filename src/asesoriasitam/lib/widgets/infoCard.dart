import 'package:asesoriasitam/palette.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String? title, content;
  const InfoCard({Key? key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var c = content;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Palette.ultraLight,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.info,
                color: Palette.mainGreen,
              ),
              SizedBox(height: 4),
              c != null
                  ? Text(
                      c,
                      style: TextStyle(color: Palette.mainGreen),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
