import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Screens/pendingverificationpage.dart';
import '../Screens/profile.dart';
import '../auth_screens/loginpage.dart';
import 'appconstants.dart';
import 'authorizeuser.dart';
var user=currentUserDataMethod().then((docs){
  if(docs.docs[0].exists){
    docs.docs[0].get('role');
  }
});

Drawer buildDrawer(BuildContext context) {
  return Drawer(elevation: 100,
    child: StreamBuilder(
        stream:FirebaseFirestore.instance.collection('users').where('uid',isEqualTo: FirebaseServices().user!.uid).snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.docs[0];
          return ListView(
              children: [
                DrawerHeader(
                    child: Container(
                        padding: EdgeInsets.only(left: 20),
                        margin: EdgeInsets.all(0),
                        color: Color(colour),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(data['name'],
                                        style: TextStyle(
                                            fontFamily: 'Times New Roman',
                                            fontSize: 20,
                                            color: Colors.white)),
                                    Text(data['email'],
                                        style: TextStyle(
                                            fontFamily: 'Times New Roman',
                                            fontSize: 10,
                                            color: Colors.white)),
                                  ],
                                ))
                            ,
                            Expanded(
                                child: Transform.scale(scale: 1, child: Image
                                    .asset(
                                  'assets/splash.png', color: Colors.white,)))
                          ],
                        ))),
                InkWell(
                  child: ListTile(
                    title: Text('Home'),
                    leading: Icon(Icons.home, color: Color(colour),),
                  ),
                ),
                InkWell(
                  onTap:(){Navigator.pushNamed(context,Profile.id);},
                  child: ListTile(
                    title: Text('Profile'),
                    leading: Icon(Icons.person, color: Color(colour),),
                  ),
                ),

                data['role'] != 'admin' ? Text('') :  InkWell(
                  onTap: () {
                    Navigator.pushNamed(context,PendingVerification.id);
                  },
                  child: ListTile(
                    title: Text('Pending verifications'),
                    leading: Icon(
                      Icons.pending_actions_outlined, color: Color(colour),),
                  ),
                ),
                // data['role'] != 'admin' ? Text('') : ListTile(
                //   title: Text('Add category'),
                //   leading: Icon(Icons.add_box_rounded, color: Color(colour),),
                // ),
                GestureDetector(onTap: () async {
                  signout(context);
                },
                    child: ListTile(title: Text('Logout'),
                      leading: Icon(
                        Icons.logout, color: Color(colour),),))
              ]
          );
        }
    ),
  );

}
void signout(BuildContext context)
{
  FirebaseAuth.instance.signOut().then((value) {
    Fluttertoast.showToast(msg: "Logout Successfully").then((value){
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()) );
    });
  }).catchError((onError){
    Fluttertoast.showToast(msg: onError.toString());
  });
}