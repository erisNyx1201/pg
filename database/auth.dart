// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //sign in anon
  Future signInAnon() async {
    try{
      UserCredential userCredential = await _auth.signInAnonymously();
      DocumentSnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
          .collection('fileUpload')
          .doc(_auth.currentUser!.uid).get();

      if(result.data() == null) {
        await FirebaseFirestore.instance
            .collection('fileUpload')
            .doc(_auth.currentUser!.uid)
            .set(
            {
              'counter': 0,
              'recent': [],
            }
        );
      }
      User? user = userCredential.user;
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  User? get user {
    return _auth.currentUser;
  }
}
