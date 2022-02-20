import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pgsupervisor/others/colors.dart';
import 'package:pgsupervisor/provider/google_sign_in.dart';
import 'package:pgsupervisor/screen/dashboard/dashStudent.dart';
import 'package:provider/provider.dart';


class StudentLogin extends StatefulWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<StudentLogin> {

  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.kDarkYellow,
      appBar: AppBar(
        backgroundColor: CustomColor.kDarkYellow,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo_upm.png', fit: BoxFit.contain,height: 50,),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Student Login',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.red[900]),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/line.png'),
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,

            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40),

          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Image(image: AssetImage("assets/student_boy.png")),

                SizedBox(height: 30.0),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.red[700],
                      minimumSize: Size.fromHeight(50)
                  ),
                  icon: FaIcon(FontAwesomeIcons.google),
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                    provider.googleLogin();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashStudent(),
                      ),
                    );
                  },
                  label: Text(
                    'Login with Google',
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                Row(
                  children: <Widget>[
                    Expanded(child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.white,
                          height: 36,
                        )),
                    ),
                    Text("OR", style: TextStyle(color: Colors.white, fontSize: 20),),
                    Expanded(child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.white,
                          height: 36,
                        )),
                    ),
                  ],
                ),

                Text('Quick login with Touch ID',style: TextStyle(fontSize: 20,color: Colors.white),),

                SizedBox(height: 20.0),

                GestureDetector(
                  onTap: () async {
                    bool weCanCheckBiometrics = await localAuth.canCheckBiometrics;

                    if(weCanCheckBiometrics){

                      bool authenticated = await localAuth.authenticate(
                        localizedReason: 'Authenticate first!',
                        useErrorDialogs: true,
                        stickyAuth: true,
                      );

                      if(authenticated){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashStudent(),
                          ),
                        );
                      }
                    } else {
                      print('Not available!');
                    }
                  },

                  child: Icon(
                    Icons.fingerprint,
                    size: 70,
                    color: Colors.red[900],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

