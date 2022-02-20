
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pgsupervisor/model/files.dart';
import 'package:pgsupervisor/others/colors.dart';
import 'package:pgsupervisor/staffthing/firebase_api.dart';
import 'package:pgsupervisor/staffthing/viewFile.dart';

class displayFile extends StatefulWidget {
  @override
  _displayFileState createState() => _displayFileState();
}

class _displayFileState extends State<displayFile> {
  late Future<List<Files>> futureFiles;

  @override
  void initState() {
    super.initState();

    futureFiles = retrieveFile.listAll('files/') as Future<List<Files>>;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: CustomColor.kLightYellow2,
        appBar: AppBar(
         title: Text('Files uploaded',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.red[900]),),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.grey, //change your color here
        ),
        ),
        body: FutureBuilder<List<Files>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(files.length),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];

                            return buildFile(context, file);
                          },
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      );

  Widget buildFile(BuildContext context, Files file) => ListTile(
        leading: Icon(
          Icons.file_copy_outlined
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: CustomColor.dark_cyan,
          ),
        ),
        onTap: () {},
      );

  Widget buildHeader(int length) => ListTile(
        tileColor: CustomColor.kRed,
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
}