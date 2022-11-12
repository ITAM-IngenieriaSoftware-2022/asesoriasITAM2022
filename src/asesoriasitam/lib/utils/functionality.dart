import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String shortenNumber(int number) {
  if (number < 999) {
    return number.toString();
  } else if (number > 999 && number < 999999) {
    return "${number / 1000}k";
  } else {
    return "${number / 1000000}m";
  }
}

Future<dynamic> goto(BuildContext context, Widget widget, [bool push = true]) {
  if (!push) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );
  } else {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
  }
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchURLToMail({required String mail}) async {
  final url = "mailto:" + mail;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

String allWordsCapitalize(String str) {
  return str.toLowerCase().split(' ').map((word) {
    String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
    return word[0].toUpperCase() + leftText;
  }).join(' ');
}

void showSnack(
    {required BuildContext context,
    required String text,
    int durationInSeconds = 1}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: Duration(seconds: durationInSeconds),
  ));
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

String dayMonthYear(DateTime d) {
  return "${d.day.toString()}/${d.month.toString()}/${d.year.toString().substring(2)}";
}
