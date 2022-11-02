import 'package:flutter/material.dart';

Widget loadingColumn() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CircularProgressIndicator()],
      )
    ],
  );
}

Widget loadingScreen() {
  return Scaffold(body: loadingColumn());
}
