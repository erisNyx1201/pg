import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:pg/id.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:pg/screen/calendar_client.dart';
import 'package:pg/screen/welcome.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var _clientID = ClientId(Secret.getId(), "");
  const _scopes = [cal.CalendarApi.calendarScope];
  await clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) async {
    CalendarClient.calendar = cal.CalendarApi(client);

    runApp( MyApp());
  });
}

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[800],
        dividerColor: Colors.black,
      ),

      title: 'PG Advisor',
      home: Welcome(),
      //Welcome(),
    );
  }
}