// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgsupervisor/database/storage.dart';
import 'package:pgsupervisor/model/event_info.dart';
import 'package:pgsupervisor/others/colors.dart';
import 'package:pgsupervisor/screen/create_screen.dart';
import 'package:pgsupervisor/screen/edit_screen.dart';
import 'package:pgsupervisor/staffthing/add_file.dart';
import 'package:pgsupervisor/staffthing/student_list.dart';
import 'package:pgsupervisor/studentprofile/profile_page.dart';

class DashStaff extends StatefulWidget {
  @override
  _DashStaff createState() => _DashStaff();
}

class _DashStaff extends State<DashStaff> {
  Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 150,
        elevation: 0,
        backgroundColor: CustomColor.kDarkYellow,
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Meeting Board',
              style: TextStyle(
                  color: CustomColor.kDarkBlue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: CustomColor.kBlue,
                  radius: 40.0,
                  backgroundImage: AssetImage(
                    'assets/avatar.png',
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Danish ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: CustomColor.sea_blue,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'Supervisor',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    Row(children: [
                      Container(
                      child: Row(
                        children: [
                          FloatingActionButton.small(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddFiles(),
                                ),
                              );
                            },
                            tooltip: 'Upload Files',
                            child: Icon(Icons.camera_enhance_rounded),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          FloatingActionButton.small(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentList(),
                                ),
                              );
                            },
                            tooltip: 'Profile',
                            child: Icon(Icons.people),
                          ),
                        ],
                      ),
                    ),
                    ],)
                    




                  ],
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.kRed,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateScreen(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          padding: EdgeInsets.only(top: 8.0),
          color: Colors.white,
          child: StreamBuilder(
            stream: storage.retrieveEvents(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length > 0) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> eventInfo =
                          snapshot.data.docs[index].data();

                      EventInfo event = EventInfo.fromMap(eventInfo);

                      DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
                          event.startTimeInEpoch);
                      DateTime endTime = DateTime.fromMillisecondsSinceEpoch(
                          event.endTimeInEpoch);

                      String startTimeString =
                          DateFormat.jm().format(startTime);
                      String endTimeString = DateFormat.jm().format(endTime);
                      String dateString = DateFormat.yMMMMd().format(startTime);

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditScreen(event: event),
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  bottom: 16.0,
                                  top: 16.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: CustomColor.kLightYellow2,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name,
                                      style: TextStyle(
                                        color: CustomColor.kRed,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      event.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: CustomColor.sea_blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0),
                                      child: Text(
                                        event.link,
                                        style: TextStyle(
                                          color: CustomColor.dark_blue
                                              .withOpacity(0.5),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 5,
                                          color: CustomColor.kGreen,
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              dateString,
                                              style: TextStyle(
                                                color: CustomColor.dark_cyan,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                            Text(
                                              '$startTimeString - $endTimeString',
                                              style: TextStyle(
                                                color: CustomColor.dark_cyan,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'No Events',
                      style: TextStyle(
                        color: Colors.black38,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(CustomColor.sea_blue),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
