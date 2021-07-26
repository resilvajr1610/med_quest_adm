import 'package:flutter/material.dart';
import 'package:med_quest_adm/telas/Splash.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../RouteGenerator.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor:Color(0xff61aef5),
  secondaryHeaderColor: Color(0xffF1F5F4),
  accentColor:Color(0xff748d9b),

);

void main() {
  runApp(MaterialApp(
    theme: temaPadrao,
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
  OneSignal.shared.setAppId('f7a2d074-1661-4b62-8956-4dc0d5d052e2');
}