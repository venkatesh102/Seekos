import 'dart:io';
import 'package:seekos/main.dart';
import 'package:seekos/Screens/category.dart';
import 'package:seekos/methods/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../Screens/homescreen.dart';
import '../Screens/pendingverificationpage.dart';
import '../methods/appconstants.dart';
// String path = firebaseuser!.uid;


FirebaseFirestore firestoreRef=FirebaseFirestore.instance;
FirebaseStorage storage=FirebaseStorage.instance;


String collectionName='image';
class LivePhotoAuth extends StatefulWidget {
  const LivePhotoAuth({Key? key}) : super(key: key);
  static const String id='livephotoauth';

  @override
  State<LivePhotoAuth> createState() => _LivePhotoAuthState();
}
ImagePicker imagepicker=ImagePicker();
class _LivePhotoAuthState extends State<LivePhotoAuth> {
  @override
  bool loading=false;
  late final imagepath;
  late final aadharpath;
  String aadharName="";
  String imageName="";
  String url="";
  List<Map> files=[];
  FirebaseServices _firebaseServices=FirebaseServices();
  var _formkey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      body:  loading?Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Column(children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Color(colour),
                gradient: LinearGradient(colors: [
                  Color(colour),
                  Color(0xff9ae9f7),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:(){Navigator.pushNamed(context, HomeScreen.id);},
                      child: Container(
                          margin: EdgeInsets.only(top:30,right: 20, left: 20),
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "SKIP",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Transform.scale(
                            scale: 1, child: Image.asset("assets/splash.png"))),
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(right: 10, left: 10,bottom: 10),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Identity Verification",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Times New Roman',
                              fontWeight: FontWeight.bold),
                        ),),
                  )
                ],
              ),
            ),
          ),
          Form(
            key: _formkey,
            child: GestureDetector(
              onTap: () {
                ImagePicker();
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Icon(
                    Icons.camera_alt,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'UPLOAD LIVE PHOTO',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [(Color(colour)), Color(0xff9ae9f7)]),
                    borderRadius: BorderRadius.circular(10),
                    color: Color(colour)),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // _takeaadhar();
              FilePicker1();
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.upload_file,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'UPLOAD AADHARD CARD',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [(Color(colour)), Color(0xff9ae9f7)]),
                  borderRadius: BorderRadius.circular(10),
                  color: Color(colour)),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (imagepath!=null&&aadharpath!=null) {
                _uploadimage('image','photourl',imagepath!);
                _uploadimage('aadhar','aadharurl',aadharpath!);
                // uploadaadhar();
                firestoreRef.collection('users').doc(_firebaseServices.user!.uid).update({
                  'status':'requested'
                }).then((value) {
                  print("uploaded successfully");
                  Message(context,"Files uploaded Successfully");
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      HomeScreen.id,
                          (Route<dynamic> route) => false);
                });
              } else {
                Message(context,'No file Selected');
              }
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(20, 50, 20, 10),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'SUBMIT',
                style: TextStyle(color: Colors.white),
              ),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     colors: [(Color(0xffF5591E)), Color(0xffF2861E)]),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.green),
            ),
          ),
        ]),
      ),
    );
  }

  ImagePicker() async {
    setState(() {
      loading=true;
    });
    // _imageloading=true;
    final image =
    await imagepicker.pickImage(source: ImageSource.camera,);
    if(image != null) {
      setState(() {
        imagepath=image;
        imageName=image.name.toString();
      });

      setState(() {
        loading=false;
      });
      Message(context, 'Image Selected successfully');
    }
    else{
      setState(() {
        loading=false;
      });
      Message(context, 'No Image Selected');
    }
  }
  FilePicker1() async {
    setState(() {
      loading=true;
    });
    // _imageloading=true;
    final image =
    await imagepicker.pickImage(source: ImageSource.gallery,);
    if(image != null) {
      setState(() {
        aadharpath=image;
        aadharName=image.name.toString();
      });
      setState(() {
        loading=false;
      });
      Message(context, "File selected Successfully");
    }
    else{
      setState(() {
        loading=false;
      });
      Message(context, 'No file Selected');
    }
  }

  _uploadimage(String subpath,String collection,final pathtype) async{
    // String uploadFileName=DateTime.now().millisecondsSinceEpoch.toString()+'.jpg';
    Reference reference =  storage.ref().child('unverifieduser').child(subpath).child(_firebaseServices.user!.uid);
    UploadTask uploadTask=reference.putFile(File(pathtype!.path));
    uploadTask.snapshotEvents.listen((event) {});
    await uploadTask.whenComplete(() async {
      var uploadPath=await uploadTask.snapshot.ref.getDownloadURL();
      firestoreRef.collection('users').doc(_firebaseServices.user!.uid).update({
        collection:uploadPath
      }).then((value) {
        print("uploaded successfully");
      });
    });
  }


}

// _takeaadhar() async {
//   double progress = 0;
//   final aadhar = await FilePicker.platform.pickFiles(
//       allowCompression: true,
//       type: FileType.custom,
//       allowMultiple: false,
//       allowedExtensions: ['pdf','png','jpg']);
//   final filepath = aadhar?.files.single.path!;
//
//   if (aadhar == null) {
//     Fluttertoast.showToast(msg: 'No file selected');
//     return;
//   }
//   else{
//     setState(() {
//       aadharpath=filepath;
//       aadharName=filepath.toString();
//     });
//     Fluttertoast.showToast(msg: "File selected successfully");
//   }
// }