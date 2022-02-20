import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:pgsupervisor/others/colors.dart';
import 'package:pgsupervisor/staffthing/button_widget.dart';
import 'package:pgsupervisor/staffthing/displayFile.dart';
import 'package:pgsupervisor/staffthing/firebase_api.dart';



class AddFiles extends StatefulWidget {
  @override
  _AddFilesState createState() => _AddFilesState();
}

class _AddFilesState extends State<AddFiles> {
  UploadTask? task;
  File? file;

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return Scaffold(
      backgroundColor: CustomColor.kLightYellow2,
      appBar: AppBar(
        title: Text('Upload Files',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.red[900]),),
        centerTitle: true,
        backgroundColor: CustomColor.kLightYellow2,
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fileName,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              ButtonWidget(
                text: 'Select File',
                icon: Icons.attach_file,
                onClicked: selectFile,
              ),
              SizedBox(height: 20),
              
             
              ButtonWidget(
                text: 'Upload File',
                icon: Icons.cloud_upload_outlined,
                onClicked: uploadFile,
              ),
              SizedBox(height: 8),
              task != null ? buildUploadStatus(task!) : Container(),
              SizedBox(height: 8),
              ButtonWidget(
                text: 'Retrieve File',
                icon: Icons.file_download_done,
                onClicked: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => displayFile(),
                                ),
                              );
                            },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  
}