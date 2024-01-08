import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth_screens/registrationpage.dart';
Future<void> PostUserdataToFirebase(BuildContext context) async {
  var user = FirebaseAuth.instance.currentUser;
  Usermodel usermodel = Usermodel(
      name: name.text,
      email: email.text,
      phone_number: phone_number.text,
      role: 'user',
      uid: user!.uid,
      photourl: '',
      aadharurl: '',
      status: 'unverified',
      location: location.text);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference ref = FirebaseFirestore.instance.collection("users");
  ref.doc(user.uid).set(usermodel.toMap()).then((value) {
   Message(context,'Registered Successfuly');
  });
}
class Usermodel {
  late String name;
  late String email;
  late String phone_number;
  late String role;
  late String uid;
  late String photourl;
  late String aadharurl;
  late String status;
  late String location;
  Usermodel(
      {required this.name,
        required this.email,
        required this.phone_number,
        required this.role,
        required this.uid,
        required this.photourl,
        required this.aadharurl,
        required this.location,
        required this.status});
  toMap() {
    return {
      'name': name,
      'phone_number': phone_number,
      'email': email,
      'role': role,
      'uid': uid,
      'photourl': photourl,
      'aadharurl': aadharurl,
      'status': status,
      'location': location
    };
  }

  factory Usermodel.fromMap(Map map) {
    return Usermodel(
        name: map['name'],
        email: map["email"],
        phone_number: map["phone_number"],
        role: map['role'],
        uid: map["uid"],
        photourl: map['photourl'],
        aadharurl: map['aadharurl'],
        status: map['status'],
        location: map['location']);
  }
}
