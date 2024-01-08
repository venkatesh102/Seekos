

import 'dart:io';

import '../main.dart';
import '../methods/appconstants.dart';
import '../methods/providerclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../auth_screens/identityverification.dart';
import 'pendingverificationpage.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const String id = 'profile';
  @override
  State<Profile> createState() => _ProfileState();
}

TextEditingController name = TextEditingController();

class _ProfileState extends State<Profile> {
  @override
  FirebaseServices _services = FirebaseServices();
  File? profilepicture;
  bool loading=false;
  var _name;
  var _phone_number;
  var _countrycode ;
  var _location ;
  var _email;
  final _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(colour),
        title: Text('Profile'),
      ),
      body:loading?Center(child: CircularProgressIndicator()): StreamBuilder<QuerySnapshot>(
          stream: _services.users
              .where('uid', isEqualTo: _services.user!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.connectionState==ConnectionState.none){
              return Center(child: CircularProgressIndicator(),);
            }
            if (snapshot.hasData) {
              var data = snapshot.data!.docs[0];
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){ImagePicker();},
                          child:Align(alignment:Alignment.center,child:CircleAvatar( radius:100 ,backgroundColor: Color(colour),child: ClipOval(child: SizedBox(width:180,height:180,child: profilepicture!=null?Image.file(profilepicture!,fit: BoxFit.fill,):Image.network(data['profilepicture'],fit: BoxFit.fill,))),) ,
                        ),),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          initialValue: data['name'],
                          validator: (item){
                            return item!.length>1?null:'Name should not empty';
                          },
                          keyboardType: TextInputType.name,
                          onChanged: (item){
                            setState(() {
                              _name=item!=null?item:data['name'];
                            });},
                          enabled: true,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          // controller: data['email'],
                          initialValue:data['email'],
                          decoration: InputDecoration(
                              enabled: false, labelText: 'Email'),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                  initialValue: '+91',
                                  onChanged: (item){setState(() {
                                    _countrycode=item;
                                  });},
                                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                                  decoration: InputDecoration(labelText: 'C.code'),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                flex: 3,
                                child: TextFormField(
                                  initialValue: data['phone_number']!=null?data['phone_number']:null,
                                  validator: (item){ if (item?.length == 10 || item?.length == 0) {
                                    return null;
                                  } else {
                                    return 'Enter correct phone number';
                                  }
                                  },
                                  onChanged: (item){setState(() {
                                    _phone_number=item;
                                  });},
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Phone Number'),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: data['location'],
                          onChanged: (item){setState(() {
                            _location=item;
                          });},
                          validator: (item){
                            return item!.length>0?null:'Location not be null';
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(labelText: 'Location'),
                        ),
                        SizedBox(height: 50,),
                        GestureDetector(
                          onTap: () {
                            updateprofile(context, data['name'], data['phone_number'], data['location']);
                            // setState(() {
                            setState(() {
                              _services.user!.reload();
                            });
                            // });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              'CONFIRM',
                              style: TextStyle(color: Colors.white),
                            ),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [(Color(colour)), Color(0xff9ae9f7)]),
                                borderRadius: BorderRadius.circular(50),
                                color: Color(colour)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  void updateprofile(BuildContext context,var name,var phone,var location) {
    setState(() {
      loading=true;
    });
    if (_formkey.currentState!.validate()) {
      uploadimage();
      firestoreRef.collection('users').doc(_services.user!.uid).update({
        'name': _name!=null?_name:name,
        'phone_number': _phone_number!=null?_phone_number:phone,
        'location': _location!=null?_location:location,
      }).then((value) {
        setState(() {
          loading=false;
        });
        Message(context, 'Updated Successfully');
      }).catchError((onError) {
        Message(context, onError.toString());
      });

    }
    else{
      Message(context, 'Please fill the required fields');
    }
  }

  ImagePicker() async {
    final profilepicture = await imagepicker.pickImage(
      source: ImageSource.gallery,
    );
    if (profilepicture == null) return;
    final temprory = File(profilepicture.path);
    setState(() {
      this.profilepicture = temprory;
    });
  }

  Future<void> uploadimage() async {
    Reference reference =
    storage.ref().child('profilepicture').child(_services.user!.uid);
    UploadTask uploadTask = reference.putFile(File(profilepicture!.path));
    uploadTask.snapshotEvents.listen((event) {});
    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      firestoreRef
          .collection('users')
          .doc(_services.user!.uid)
          .update({'profilepicture': uploadPath});
    });
  }
}

// Footer
// © 2023 GitHub, Inc.
// Footer navigation
// Terms
// Privacy
// Security
// Status
// Docs
// Contact GitHub
// Pricing
// API
// Training
// Blog
// About
