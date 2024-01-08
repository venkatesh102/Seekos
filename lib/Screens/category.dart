import '../Screens/subcategories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pendingverificationpage.dart';
import '../Screens/seeall.dart';

import '../methods/appconstants.dart';


class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);
static const String id='categories';
  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream: _service.categories.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('');
          }
          return Container(
              height: 160,
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Categories',style:TextStyle(fontSize:15)),
                      Container(color: Colors.white,
                          child:OutlinedButton(
                            style:  OutlinedButton.styleFrom(
                                side: BorderSide(width:0, color: Colors.white),),
                            // style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary),),
                        onPressed: (){Navigator.pushNamed(context,SeeAll.id);},
                          child: Row(
                        children: [
                          Text('See all',style: TextStyle(color: Color(colour)),),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(Icons.arrow_forward_ios,color: Color(colour),size: 20,)
                        ],
                      )))
                    ],
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data!.docs[index];
                          return InkWell(
                            onTap: (){Navigator.pushNamed(context, SubCategories.id,arguments:data);},
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Column(
                                children: [Image.network(data['image']),SizedBox(height: 10,),Flexible(flex:1,fit:FlexFit.loose,child: Text(data['CatName'],maxLines: 2,textAlign: TextAlign.center,style: TextStyle(fontSize: 10),),)],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ));
        },
      ),
    );
  }
}
