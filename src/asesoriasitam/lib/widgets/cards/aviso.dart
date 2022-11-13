import 'package:asesoriasitam/palette.dart';
import 'package:flutter/material.dart';

class AvisoCard extends StatelessWidget {
  final int cardHeight;
  final String? image, signedBy, title, texto;
  const AvisoCard(
      {Key? key,
      this.image,
      this.signedBy,
      this.title,
      this.texto,
      this.cardHeight = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Palette.ultraLight,
      clipBehavior: Clip.hardEdge,
      child: Container(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: texto != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title != null
                      ? Text(
                          title!,
                          style: TextStyle(
                              fontSize: 20,
                              color: Palette.mainGreen,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )
                      : Container(),
                  texto != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            texto!,
                            style: TextStyle(
                                fontSize: 14, color: Palette.mainGreen),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        )
                      : Container(),
                  signedBy != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            signedBy!,
                            style: TextStyle(color: Palette.mainGreen),
                          ),
                        )
                      : Container()
                ],
              )
            : Container(),
      )),
    );
  }
}
