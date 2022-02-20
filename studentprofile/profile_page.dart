import 'package:flutter/material.dart';
import 'package:pg/studentprofile/profile_widget.dart';
import 'package:pg/studentprofile/socmed_widget.dart';
import 'package:pg/model/student.dart';
import 'package:pg/studentprofile/user_preference.dart';

import 'appbar_widget.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProfilePage());
}
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final style = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    //access my user
    final user = UserPrefeerences.myUser;

    return Scaffold(
      appBar: buildAppbar(context),

      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(imagePath: user.imagePath, onClicked: () async {}),
          const SizedBox(
            height: 24,
          ),
          buildName(user),
          const SizedBox(
            height: 24,
          ),

          SocMed(),

          const SizedBox(
            height: 24,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Comments',
              style: style,
            ),
          ),

          Divider(thickness: 1.0, color: Colors.grey.shade400),

          buildAbout(user)
        ],
      ),
    );
  }

  Widget buildName(Student user) => Column(
    children: [
      Text(user.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),


      const SizedBox(
        height: 20,
      ),


      Text(
        user.email,
        style: TextStyle(color: Colors.grey),
      ),

      Text(
        user.noMatric,
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold) ,
      )
    ],
  );


  Widget buildAbout(Student user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 16),
        Text(
          user.about,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}
