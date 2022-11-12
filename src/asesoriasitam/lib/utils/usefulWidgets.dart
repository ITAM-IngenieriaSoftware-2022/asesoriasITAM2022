import 'package:flutter/material.dart';

Widget CenteredConstrainedBox({double maxWidth = 500, required Widget child}) {
  return Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
