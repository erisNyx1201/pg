
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

AppBar buildAppbar (BuildContext context){
  final icon = CupertinoIcons.moon_stars;

  return AppBar(
    leading: BackButton(),
    backgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(
      color: Colors.grey, //change your color here
    ),
    elevation: 0,
    actions: [


      IconButton(
        icon: Icon(icon),
        onPressed: (){},
      ),
    ],
  );


}