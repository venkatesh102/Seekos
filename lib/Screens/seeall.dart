import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../methods/appconstants.dart';
import 'pendingverificationpage.dart';
import 'subcategories.dart';

class SeeAll extends StatefulWidget {
  const SeeAll({Key? key}) : super(key: key);
  static const String id = 'seeall';
  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  FirebaseServices _firebaseServices = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(colour), title: Text('Categories')),
      body: FutureBuilder(
        future: _firebaseServices.categories.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return GestureDetector(
                    onTap: () {
                      if (data['subCat'] != null) {
                        Navigator.pushNamed(context, SubCategories.id,
                            arguments: data);
                      }
                    },
                    child: SizedBox(
                        height: 100,
                        child: ListTile(
                          leading: Image.network(data['image']),
                          title: Text(
                            data['CatName'],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Color(colour),
                          ),
                        )));
              });
        },
      ),
    );
  }
}


