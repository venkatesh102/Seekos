import '../Screens/homescreen.dart';
import '../Screens/pendingverificationpage.dart';
import '../Screens/sell_categories_selectpage.dart';
import '../methods/appconstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth_screens/identityverification.dart';
// import 'chat_history.dart';
// import 'chat_screen.dart';
class BottomNavigationBarPage extends StatefulWidget {
  const BottomNavigationBarPage({Key? key}) : super(key: key);
  static const String id = 'homescreen';
  @override
  State<BottomNavigationBarPage> createState() => _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  int _index = 0;
  @override
  FirebaseServices _services=FirebaseServices();

  Widget _currentSceen = HomeScreen();
  final PageStorageBucket _bucket = PageStorageBucket();
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection('users').where('uid',isEqualTo: FirebaseServices().user!.uid).snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasData){
          var data=snapshot.data!.docs[0];
          return Scaffold(
            body: PageStorage(
              bucket: _bucket,
              child: _currentSceen,
            ),
      // if()
      floatingActionButton:data['role']=='admin'?FloatingActionButton(
        child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              'POST',
              style: TextstyleActive,
            )),
        onPressed: () {
          data['status']=='verified'?Navigator.pushNamed(context, SellCategoriesSelectPage.id):showDialog(context: context, builder: (context){
            return Container(child: AlertDialog(title:Text('You need to verify your identity to sell item'),actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>LivePhotoAuth()));}, child: Text('Verify now'))],),);
          });
        },
        backgroundColor: Color(colour),
        elevation: 0.0,
      ):Text(''),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:EdgeInsets.zero,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 0, color: Colors.white)),
                        onPressed: () {
                          setState(() {
                            _index = 0;
                            _currentSceen = HomeScreen();
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _index == 0 ? Icons.home : Icons.home_outlined,
                              color: _index == 0 ? Color(colour) : Colors.black,
                            ),
                            Text(
                              'HOME',
                              style:
                              _index == 0 ? TextstyleActive : TextstyleInActive,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                      style:OutlinedButton.styleFrom(
            side: BorderSide(width: 0, color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          _index = 1;
                          _currentSceen = Container();
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _index == 1 ? Icons.chat : Icons.chat_outlined,
                            color: _index == 1 ? Color(colour) : Colors.black,
                          ),
                          Text('CHATS',
                              style: _index == 1
                                  ? TextstyleActive
                                  : TextstyleInActive),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              // Expanded(child: SizedBox(width:10,child: Container())) ,
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Padding(
                        padding:EdgeInsets.zero,
                        child: OutlinedButton(
                          style:OutlinedButton.styleFrom(
                              side: BorderSide(width: 0, color: Colors.white)),
                          onPressed: () {

                            setState(() {
                              _index = 2;
                              _currentSceen = Container();
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _index == 2
                                    ? Icons.work_history
                                    : Icons.work_history_outlined,
                                color: _index == 2 ? Color(colour) : Colors.black,
                              ),
                              Text(
                                'FAV',
                                style:
                                _index == 2 ? TextstyleActive : TextstyleInActive,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.zero,
                        child: OutlinedButton(
                          style:OutlinedButton.styleFrom(
                              side: BorderSide(width: 0, color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              _index = 3;
                              _currentSceen = Container();
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _index == 3
                                    ? CupertinoIcons.cart_fill
                                    : CupertinoIcons.cart,
                                color: _index == 3 ? Color(colour) : Colors.black,
                              ),
                              Text('CART',
                                  style: _index == 3
                                      ? TextstyleActive
                                      : TextstyleInActive),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width: 20,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));}
          else{
          return CircularProgressIndicator();}
          })
    );
  }

  TextStyle get TextstyleActive => TextStyle(
      color: Color(colour), fontSize: 12, fontWeight: FontWeight.bold);
  TextStyle get TextstyleInActive => TextStyle(
      color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal);
}
