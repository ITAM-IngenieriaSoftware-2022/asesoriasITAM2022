import 'package:flutter/material.dart';

Widget unuColumn({required BuildContext context, required String texto}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("UnU",
            style: TextStyle(fontSize: 50, color: Theme.of(context).hintColor)),
        Text(texto,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).hintColor)),
      ],
    ),
  );
}

Widget unuScreen({required BuildContext context, required String texto}) {
  return Scaffold(
    appBar: AppBar(),
    body: unuColumn(context: context, texto: texto),
  );
}
