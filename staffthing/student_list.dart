// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pgsupervisor/others/colors.dart';
import 'package:pgsupervisor/screen/dashboard/dashStudent.dart';
import 'package:pgsupervisor/studentprofile/profile_page.dart';

class StudentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColor.kLightYellow2,
        iconTheme: const IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: const Text(
          'List of Student',
          style: TextStyle(
            color: CustomColor.dark_blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: CustomColor.kLightYellow2,
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children:  <Widget>[
            ListTile(
              contentPadding: EdgeInsets.only(top: 3.0,bottom: 3.0),
              leading: CircleAvatar(
                backgroundColor: CustomColor.kBlue,
                radius: 35.0,
                backgroundImage: AssetImage(
                  'assets/avatargirl.png',
                ),
              ),
              title: Text('Sarah',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: CustomColor.sea_blue,
                    fontWeight: FontWeight.w700,
                  )),
              subtitle: Text('204433@gmail.com'),
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
            ),
            ListTile(
              contentPadding: EdgeInsets.only(top: 3.0,bottom: 3.0),
              leading: CircleAvatar(
                backgroundColor: CustomColor.kBlue,
                radius: 35.0,
                backgroundImage: AssetImage(
                  'assets/avatargirl.png',
                ),
              ),
              title: Text(
                'Suraiya',
                style: TextStyle(
                  fontSize: 22.0,
                  color: CustomColor.sea_blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text('207361@gmail.com'),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(top: 3.0,bottom: 3.0),
              leading: CircleAvatar(
                backgroundColor: CustomColor.kBlue,
                radius: 35.0,
                backgroundImage: AssetImage(
                  'assets/avatar.png',
                ),
              ),
              title: Text(
                'Aiman',
                style: TextStyle(
                  fontSize: 22.0,
                  color: CustomColor.sea_blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text('201186@gmail.com'),
            ),
          ],
        ),
      ),
    );
  }
}
