import 'package:asesoriasitam/db/usuario_bloc.dart';
import 'package:flutter/material.dart';

///Opens modal sheet, user selects reason for report and sends it to reportes collection.
void showReportar(
    {required BuildContext context, required Map<String, dynamic> data}) {
  final _showEnviado = () => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text("Ok"))
            ],
            title: Text("Reporte enviado"),
            content: Text(
                "Se ha mandado tu reporte. Lo revisaremos lo mas pronto posible y tomaremos medidas si las consideramos necesarias. Gracias por mantener una comunidad sana."),
          ));
  TextEditingController _controller = TextEditingController();
  showModalBottomSheet(
      context: context,
      builder: (context) => ListView(shrinkWrap: true, children: [
            ListTile(
              title: Text("Reportar por contenido inapropiado"),
              onTap: () async {
                Navigator.of(context).pop();
                await UsuarioBloc().reportar(data: data);
                _showEnviado();
              },
            ),
            ListTile(
                title: Text("Reportar por otra razón"),
                onTap: () async {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Reportar"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  data["razon"] = _controller.text;
                                  await UsuarioBloc().reportar(data: data);
                                  _showEnviado();
                                },
                                child: Text("Reportar"),
                              ),
                            ],
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Dinos el motivo de tu reporte y lo revisaremos lo mas pronto posible:"),
                                TextField(
                                  controller: _controller,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                      hintText: "Motivo de reporte"),
                                ),
                              ],
                            ),
                          ));
                }),
          ]));
}
