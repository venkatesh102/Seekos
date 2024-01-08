import '../Screens/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../auth_screens/identityverification.dart';
import 'drawer.dart';
authorizeAccess(BuildContext context) {
  var then = currentUserDataMethod()
      .then((docs) {
    if (docs.docs[0].exists) {
      if (docs.docs[0].get('role') == 'admin') {
        Navigator.of(context).pushReplacementNamed(
           HomeScreen.id);
      } else {
        Navigator.of(context).pushReplacementNamed(LivePhotoAuth.id);
      }
    }
  }).catchError((onError){
    Fluttertoast.showToast(msg: onError.toString());
  });
}

Future<QuerySnapshot<Map<String, dynamic>>> currentUserDataMethod() async {
  return await FirebaseFirestore.instance
      .collection('/users')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
}