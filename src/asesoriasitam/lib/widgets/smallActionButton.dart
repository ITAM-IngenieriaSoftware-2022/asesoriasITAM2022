import 'package:asesoriasitam/palette.dart';
import 'package:flutter/material.dart';

class SmallActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSubmitting;
  final double maxWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  const SmallActionButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.isSubmitting = false,
      this.maxWidth = 100,
      this.backgroundColor = Palette.mainYellow,
      this.foregroundColor = Palette.mainBrown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
            foregroundColor: MaterialStateProperty.all<Color>(foregroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ))),
        onPressed: !isSubmitting ? onPressed : null,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: !isSubmitting
                ? Text(text,
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 16))
                : Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: foregroundColor,
                      strokeWidth: 2,
                    )),
          ),
        ),
      ),
    );
  }
}
