// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocMed extends StatelessWidget {
  const SocMed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        InkWell(
          onTap: () {
            openWhatsapp();
          },
          child: Ink.image(
            image: AssetImage('assets/whatsapp.png'),
            // fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
        ),


        InkWell(
          onTap: () {
            openGmail();

          },
          child: Ink.image(
            image: AssetImage('assets/gmail.png'),
            // fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
        ),

        InkWell(
          onTap: () {
            onCall();

          },
          child: Ink.image(
            image: AssetImage('assets/call.png'),
            // fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),
        ),


      ],
    );
  }

  void openWhatsapp() async {
    String number = '601117950194';
    var url = 'https://wa.me/$number?text=Hello';
    if( await canLaunch(url)) {
      await launch(url);
    } else{
      print('Error');
      throw 'Error occured';
    }
  }

  void onCall() async {
    const url = 'tel:+601117950194';
    if( await canLaunch(url)){
      await launch(url);
    } else{
      throw 'Could not launch $url';

    }
  }

  void openGmail() async {
    final toEmail = 'nursuraiya.mustapha@gmail.com';
    final subject = 'New post';
    final message = 'Hello and have a nice day!';

    final url = 'mailto:$toEmail?subject=${subject}&body=${message}';
    if( await canLaunch(url)){
      await launch(url);
    } else{
      throw 'Could not launch $url';

    }
  }
}