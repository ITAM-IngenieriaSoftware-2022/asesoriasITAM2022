import 'package:flutter/material.dart';

abstract class IncluyeCardTile {
  IncluyeCardTile fromMap(Map<String, dynamic> mapData);
  Widget card({required BuildContext context});
  Widget tile({required BuildContext context});
  Widget incompleteTile({required BuildContext context});
}
