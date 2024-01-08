import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../auth_screens/identityverification.dart';
import 'package:url_launcher/url_launcher.dart';
var colour=0xffF22a6d7;
class PendingVerification extends StatefulWidget {
  const PendingVerification({Key? key}) : super(key: key);
static const String id='admindashboard';
  @override
  State<PendingVerification> createState() => _PendingVerificationState();
}

class _PendingVerificationState extends State<PendingVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:Colors.blueGrey,
      appBar: AppBar(title: Text('Pending Verifications'),centerTitle: true,backgroundColor: Color(colour),),
      body: StreamBuilder(
          stream:FirebaseFirestore.instance.collection('users').where("status",isEqualTo:'requested').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data=snapshot.data!.docs[index];
                  return Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      // color: Colors.white,

                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      height: 150,
                      child: Row(children:[Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap:(){                              print('index');
                              launch(data['photourl']);
                  },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              height: 25,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.lightBlueAccent),
                              width: 100,
                              child: Text('Live photo'),
                            ),
                          ),
                          SizedBox(height: 30,),
                          GestureDetector(

                            onTap:(){
                              launch(data['aadharurl']);
                            },
                            child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.lightBlueAccent),
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              height: 25,
                              width: 100,
                              child: Text('Aadhar card'),
                            ),
                          ),
                        ],
                      ),SizedBox(width: 20,),
                        GestureDetector(
                        onTap:(){
                          setState(() {
                            firestoreRef.collection('users').doc(
                                data['uid']).update({
                              'status':'verified'
                            });
                          });
                        },
                        child: Container(
                          color: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                          height: 35,
                          // width: 100,
                          child: Text('Accept'),
                        ),
                      ),
                        SizedBox(width: 20,),
                        GestureDetector(

                          onTap:(){
                            setState(() {
                              firestoreRef.collection('users').doc(data['uid']).update({'status':'rejected'});
                            });
                          },
                          child: Container(
                            color: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            height: 35,
                            // width: 100,
                            child: Text('Reject'),
                          ),
                        ),
                      ]),
                  );
                });
          }),
    );
  }
    //   final user=await FirebaseAuth.instance.currentUser;
}
