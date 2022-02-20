import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pgsupervisor/screen/authenticate/staff_login.dart';
import 'package:pgsupervisor/screen/authenticate/student_login.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.red[700],
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(20.0),
          child: Image.asset(
            'assets/upm.png',
            height: 150,
            width: 500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.white, minimumSize: Size.fromHeight(50)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentLogin(),
                    ),
                  );
                },
                child: Text(
                  'Login as Student',
                  style: TextStyle(fontSize: 20, color: Colors.red[700]),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                  primary: Colors.red[700],
                  minimumSize: Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StaffLogin(),
                    ),
                  );
                },
                child: Text(
                  'Login as Staff',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
