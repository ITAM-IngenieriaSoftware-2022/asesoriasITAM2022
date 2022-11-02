import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AsesoriaPage extends StatelessWidget {
  const AsesoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asesoria"),
        centerTitle: true,
      ),
      body: Text("Asesoria Page"),
    );
  }
}
