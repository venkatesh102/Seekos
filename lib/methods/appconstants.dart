import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppConstants
{
  String colour='0xffF5591F';
}

class FirebaseServices {
  CollectionReference categories =
  FirebaseFirestore.instance.collection('categories');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference productData=FirebaseFirestore.instance.collection('productData');

  User? user = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot> getUserData() async
  {
    DocumentSnapshot doc=await users.doc(user!.uid).get();
    return doc;
  }
}
class LinearProgressIndicatorApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LinearProgressIndicatorAppState();
  }
}

class LinearProgressIndicatorAppState extends State<LinearProgressIndicatorApp> {
  bool _loading=false;

  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Linear Progress Bar"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: _loading ? LinearProgressIndicator() : Text(
              "Press button for downloading",
              style: TextStyle(fontSize: 25)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _loading = !_loading;
          });
        },
        tooltip: 'Download',
        child: Icon(Icons.cloud_download),
      ),
    );
  }
}