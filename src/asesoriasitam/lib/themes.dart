import 'package:asesoriasitam/palette.dart';
import 'package:flutter/material.dart';

const lightPrimary = Palette.mainGreen;
const lightAccent = Palette.mainYellow;

final lightTheme = ThemeData(
    primarySwatch: Palette.mainGreenMaterial,
    accentColor: lightPrimary,
    appBarTheme: AppBarTheme(elevation: 0.0),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor:
                MaterialStateProperty.all<Color>(Palette.mainGreen),
            overlayColor: MaterialStateProperty.all<Color>(Palette.mainGreen),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)))), //7
            elevation: MaterialStateProperty.all<double>(1.0))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(lightPrimary))));
